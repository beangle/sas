/*
 * Beangle, Agile Development Scaffold and Toolkits.
 *
 * Copyright © 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.tomcat

import java.io.{File, FileInputStream, FileOutputStream, StringWriter}
import java.net.URL
import java.time.LocalDate
import java.time.format.DateTimeFormatter

import freemarker.template.Configuration
import org.beangle.commons.activation.MediaTypes
import org.beangle.commons.config.Resources
import org.beangle.commons.file.zip.Zipper
import org.beangle.commons.io.{Dirs, Files, IOs}
import org.beangle.commons.lang.ClassLoaders.getResource
import org.beangle.commons.lang.Strings.substringAfterLast
import org.beangle.commons.lang.{ClassLoaders, Strings}
import org.beangle.repo.artifact.{Artifact, ArtifactDownloader, Repo, War}
import org.beangle.sas.daemon.ServerStatus
import org.beangle.sas.model._
import org.beangle.template.freemarker.Configurer

object TomcatMaker {

  private val cfg = Configurer.newConfig
  cfg.setTagSyntax(Configuration.SQUARE_BRACKET_TAG_SYNTAX)
  cfg.setDefaultEncoding("UTF-8")
  cfg.setNumberFormat("0.##")

  /** 增加sas对tomcat的默认要求到配置模型中。
   * @param container
   * @param engine
   */
  def applyEngineDefault(container: Container, engine: Engine): Unit = {
    if (engine.listeners.isEmpty) {
      engine.listeners += new Listener("org.apache.catalina.core.AprLifecycleListener").property("SSLEngine", "on")
      engine.listeners += new Listener("org.apache.catalina.core.JreMemoryLeakPreventionListener")
      engine.listeners += new Listener("org.apache.catalina.mbeans.GlobalResourcesLifecycleListener")
      engine.listeners += new Listener("org.apache.catalina.core.ThreadLocalLeakPreventionListener")
    }

    if (null == engine.context) engine.context = new Context()

    val context = engine.context
    if (context.loader == null) {
      context.loader = new Loader("org.apache.catalina.loader.RepositoryLoader")
    }
    if (context.jarScanner == null) {
      val scanner = new JarScanner
      scanner.properties.put("scanBootstrapClassPath", "false")
      scanner.properties.put("scanAllDirectories", "false")
      scanner.properties.put("scanAllFiles", "false")
      scanner.properties.put("scanClassPath", "false")
      scanner.properties.put("scanManifest", "false")
      context.jarScanner = scanner
    }
    //添加beangle-sas-tomcat and logback-access
    engine.jars += Jar.gav("org.beangle.sas:beangle-sas-tomcat:" + container.version)
    engine.jars += Jar.gav("ch.qos.logback:logback-access:1.3.0-alpha5")
    engine.jars += Jar.gav("ch.qos.logback:logback-core:1.3.0-alpha5")
  }

  def makeEngine(sasHome: String, engine: Engine, remote: Repo.Remote, local: Repo.Local): Unit = {
    val tomcat = new File(sasHome + "/engines/tomcat-" + engine.version)
    // tomcat not exists or empty dir
    if (!tomcat.exists() || tomcat.list().length == 0) {
      val artifact = Artifact("org.apache.tomcat:tomcat:zip:" + engine.version)
      new ArtifactDownloader(remote, local).download(List(artifact))
      val tomcatZip = new File(local.url(artifact))
      if (tomcatZip.exists()) {
        doMakeEngine(sasHome, engine, tomcatZip)
      } else {
        System.out.println("Cannot download " + artifact)
      }
    }

    engine.jars foreach { jar =>
      val jarName = jar.name
      if (!new File(tomcat, "/lib/" + jarName).exists()) {
        if (jar.url.isDefined) {
          download(jar.url.get, tomcat.getAbsolutePath + "/lib")
        } else if (jar.gav.isDefined) {
          val artifact = Artifact(jar.gav.get)
          new ArtifactDownloader(remote, local).download(List(artifact))
          Dirs.on(tomcat, "lib").ln(local.url(artifact))
        } else if (jar.path.isDefined) {
          Dirs.on(tomcat, "lib").copyFrom(jar.path.get)
        }
      }
    }
  }

  private def detectExecution(server: Server): Option[ServerStatus] = {
    val p = new ProcessBuilder("lsof", "-i", ":" + server.http).start()
    val res = IOs.readString(p.getInputStream)
    if (Strings.isNotBlank(res)) {
      val lines = Strings.split(res.trim(), "\n")
      if (lines.length > 1) {
        // java pid ....
        val elems = Strings.split(lines(1), " ")
        val pid = elems(1) //ps -f -p $PID
        val ps = new ProcessBuilder("ps", "-f", "-p", pid.trim).start()
        Some(new ServerStatus(pid.toInt, IOs.readString(ps.getInputStream)))
      } else {
        None
      }
    } else {
      None
    }
  }

  def rollLog(sasHome: String, container: Container, server: Server): Unit = {
    val d = LocalDate.now()
    val consoleOut = new File(sasHome + "/servers/" + server.qualifiedName + "/logs/console.out")
    if (consoleOut.exists()) {
      val archive = new File(sasHome + "/logs/archive/" + server.qualifiedName + s"-${d.format(DateTimeFormatter.ofPattern("yyyyMMdd"))}.out")
      if (!archive.exists()) {
        Files.touch(archive)
      }
      val os = Files.writeOpen(archive, true)
      val is = new FileInputStream(consoleOut)
      IOs.copy(is, os)
      IOs.close(is, os)
      consoleOut.delete()
    }
    Files.touch(consoleOut)
  }

  def makeServer(sasHome: String, container: Container, farm: Farm, server: Server): Unit = {
    val result = detectExecution(server)
    result match {
      case Some(e) =>
        val dirs = Dirs.on(sasHome + "/servers/" + server.qualifiedName)
        dirs.write("CATALINA_PID", e.processId.toString)
      case None =>
        doMakeBase(sasHome, container, farm, server)
        rollLog(sasHome, container, server)
    }
  }

  /** 生成一个base的目录结构和配置文件
   * @param sasHome
   * @param container
   * @param farm
   * @param server
   */
  protected[tomcat] def doMakeBase(sasHome: String, container: Container, farm: Farm, server: Server): Unit = {
    val engine = farm.engine
    val serverName = server.qualifiedName
    val base = Dirs.on(sasHome + "/servers/" + serverName)
    base.mkdirs()
    base.mkdirs("temp", "work", "conf")
    //这个文件夹可能是只读，不好删除，先设置可写
    FileUtils.setWriteable(base.cd("webapps").pwd)
    //删除这些已有文件，创建一个新环境
    base.delete("webapps", "conf", "bin").mkdirs("webapps", "conf", "bin")

    val engineHome = sasHome + "/engines/" + engine.typ + "-" + engine.version
    if (new File(engineHome).exists()) {
      base.ln(engineHome + "/lib")

      val conf = base.cd("conf")
      Dirs.on(engineHome + "/conf").ls() foreach { cf =>
        conf.ln(engineHome + "/conf/" + cf)
      }

      val bin = base.cd("bin")
      Dirs.on(engineHome + "/bin").ls() foreach { f =>
        bin.ln(engineHome + "/bin/" + f)
      }
    }
    val logs = Dirs.on(sasHome + "/logs/" + serverName)
    logs.mkdirs()
    base.ln(new File(sasHome + "/logs/" + serverName), "logs")

    container.getDeployments(server) foreach { d =>
      container.getWebapp(d.webapp) foreach { w =>
        d.unpack match {
          case Some(unpack) => if (unpack) unzipWar(base, w, d)
          case None =>
            d.unpack = Some(!War.isLibEmpty(w.docBase))
            if (d.unpack.get) {
              unzipWar(base, w, d)
            }
        }
      }
    }
    //这个文件夹设置成只读
    FileUtils.setReadOnly(base.cd("webapps").pwd)
    genBaseConfig(container, farm, server, sasHome)
  }

  protected[tomcat] def unzipWar(base: Dirs, webapp: Webapp, deployment: Deployment): Unit = {
    var path = deployment.path
    if (path.startsWith("/")) path = path.substring(1)
    if (path.endsWith("/")) path = path.substring(0, path.length - 1)
    path = path.replace("/", "#")
    if (Strings.isBlank(path)) path = "ROOT"
    val docBase = base.cd("webapps").mkdirs(path).cd(path).pwd
    Zipper.unzip(new File(webapp.docBase), docBase)
    webapp.docBase = docBase.getAbsolutePath
  }

  protected[tomcat] def genBaseConfig(container: Container, farm: Farm, server: Server, targetDir: String): Unit = {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    data.put("server", server)
    val sw = new StringWriter()
    val freemarkerTemplate = cfg.getTemplate(s"${farm.engine.typ}/conf/server.xml.ftl")
    freemarkerTemplate.process(data, sw)
    val serverDir = targetDir + "/servers/" + server.qualifiedName
    new File(serverDir).mkdirs()
    Files.writeString(new File(serverDir + "/conf/server.xml"), sw.toString)

    if (farm.jvmopts.isDefined) {
      val envTemplate = cfg.getTemplate(s"${farm.engine.typ}/bin/setenv.sh.ftl")
      val nsw = new StringWriter()
      envTemplate.process(data, nsw)
      new File(serverDir + "/bin").mkdirs()
      val target = new File(serverDir + "/bin/setenv.sh")
      Files.writeString(target, nsw.toString)
      target.setExecutable(true)
    }
  }

  protected[tomcat] def doMakeEngine(sasHome: String, engine: Engine, tomcatZip: File): Unit = {
    val engineHome = new File(sasHome + "/engines")
    engineHome.mkdirs()
    val tomcatDirname = tomcatZip.getName.replace(".zip", "")
    val version = Strings.substringAfterLast(tomcatDirname, "-")
    val engineDir = new File(engineHome.getPath + "/tomcat-" + version)
    if (engineDir.exists()) {
      Dirs.delete(engineDir)
    }
    Zipper.unzip(tomcatZip, engineHome)
    new File(engineHome.getPath + "/apache-tomcat-" + version).renameTo(engineDir)
    //delete outer dirs
    Dirs.on(engineDir).delete("work", "webapps", "logs", "temp", "RUNNING.txt")
      .delete("NOTICE", "LICENSE", "RELEASE-NOTES", "BUILDING.txt", "CONTRIBUTING.md", "README.md")

    // clean up conf
    val conf = Dirs.on(engineDir, "conf").delete("server.xml", "tomcat-users.xml", "tomcat-users.xsd",
      "jaspic-providers.xml", "jaspic-providers.xsd", "web.xml", "logging.properties")

    Set("catalina.properties") foreach { f =>
      ClassLoaders.getResourceAsStream("tomcat/conf/" + f) foreach { fi =>
        conf.write(f, IOs.readString(fi))
      }
    }

    //clean bin
    Dirs.on(engineDir, "bin").delete("startup.sh", "shutdown.sh", "configtest.sh", "version.sh",
      "digest.sh", "tool-wrapper.sh", "catalina.sh", "setclasspath.sh", "makebase.sh", "ciphers.sh", "tomcat-juli.jar")

    val bin = new File(engineDir, "bin")
    val binFiles = bin.list()
    var i = 0
    while (i < binFiles.length) {
      val bn = binFiles(i)
      val removed = bn.endsWith(".xml") || bn.endsWith(".bat") || bn.endsWith("tar.gz") || bn.contains("daemon")
      if (removed) {
        new File(bin, bn).delete()
      }
      i += 1
    }

    //clean up lib
    Dirs.on(engineDir, "lib").delete("tomcat-i18n-es.jar", "tomcat-i18n-fr.jar", "tomcat-i18n-ja.jar")

    if (!engine.jspSupport) {
      Dirs.on(engineDir, "lib").delete("jsp-api.jar", "el-api.jar", "ecj-4.6.3.jar",
        "ecj-4.7.3a.jar", "jasper.jar", "jasper-el.jar")
    }
    if (!engine.websocketSupport) {
      Dirs.on(engineDir, "lib").delete("websocket-api.jar", "tomcat-websocket.jar")
    }
    genEngineConfig(engine, engineDir.getAbsolutePath)
  }

  protected[tomcat] def genEngineConfig(engine: Engine, engineDir: String): Unit = {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("engine", engine)
    val mimetypes = MediaTypes.buildTypes(new Resources(None,
      List.empty, getResource("sas/mime.types")))
    data.put("mimetypes", mimetypes)
    val envTemplate = cfg.getTemplate(s"${engine.typ}/conf/web.xml.ftl")
    val nsw = new StringWriter()
    envTemplate.process(data, nsw)
    Files.writeString(new File(engineDir + "/conf/web.xml"), nsw.toString)
  }

  private def download(url: String, dir: String): String = {
    val fileName = substringAfterLast(url, "/")
    val destFile = new File(dir + fileName)
    if (!destFile.exists) {
      val destOs = new FileOutputStream(destFile)
      val warurl = new URL(url)
      IOs.copy(warurl.openStream(), destOs)
      destOs.close()
    }
    fileName
  }
}
