/*
 * Copyright (C) 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.beangle.sas.maker

import org.beangle.boot.artifact.{Artifact, ArtifactDownloader, Repo, War}
import org.beangle.commons.activation.MediaTypes
import org.beangle.commons.config.Resources
import org.beangle.commons.file.zip.Zipper
import org.beangle.commons.io.{Dirs, Files, IOs}
import org.beangle.commons.lang.ClassLoaders.getResource
import org.beangle.commons.lang.{ClassLoaders, Strings}
import org.beangle.sas.config.*
import org.beangle.sas.tool.SasTool

import java.io.{File, StringWriter}

object TomcatMaker {

  /** 增加sas对tomcat的默认要求到配置模型中。
   *
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
      context.loader = new Loader("org.apache.catalina.loader.WebappLoader")
      context.loader.properties.put("loaderClass", "org.beangle.sas.engine.tomcat.DependencyClassLoader")
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
    //添加beangle-sas-engine and logback-access(bump version)
    engine.jars += Jar.gav("org.beangle.sas:beangle-sas-engine:" + container.version)
    if (engine.typ == EngineType.Tomcat) {
      engine.jars += Jar.gav("ch.qos.logback:logback-access:1.4.4")
      engine.jars += Jar.gav("ch.qos.logback:logback-core:1.4.4")
    }
  }

  /** 创建一个引擎
   * 如果引擎中有内容，则不会重复创建，但会检查是否有缺失的jar.
   *
   * @param sasHome
   * @param engine
   * @param remote
   * @param local
   */
  def makeEngine(sasHome: String, engine: Engine, remotes: Seq[Repo.Remote], local: Repo.Local): Unit = {
    val tomcat = engine.dir(sasHome)
    // tomcat not exists or empty dir
    if (!tomcat.exists() || tomcat.list().length == 0) {
      val artifact = Artifact("org.apache.tomcat:tomcat:zip:" + engine.version)
      new ArtifactDownloader(remotes, local, true).download(List(artifact))
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
        if (ArchiveURI.isRemote(jar.uri)) {
          SasTool.download(jar.uri, tomcat.getAbsolutePath + "/lib")
        } else if (ArchiveURI.isGav(jar.uri)) {
          val artifact = ArchiveURI.toArtifact(jar.uri)
          new ArtifactDownloader(remotes, local, true).download(List(artifact))
          Dirs.on(tomcat, "lib").ln(local.url(artifact))
        } else {
          Dirs.on(tomcat, "lib").copyFrom(jar.uri)
        }
      }
    }
  }

  protected[maker] def doMakeEngine(sasHome: String, engine: Engine, tomcatZip: File): Unit = {
    val engineHome = new File(sasHome + "/engines")
    engineHome.mkdirs()
    val tomcatDirname = tomcatZip.getName.replace(".zip", "")
    val version = Strings.substringAfter(tomcatDirname, "-")
    val engineDir = engine.dir(sasHome)
    if engineDir.exists() then Dirs.delete(engineDir)

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
    Dirs.on(engineDir, "bin").delete("startup.sh", "shutdown.sh", "configtest.sh", "version.sh", "migrate.sh",
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

  protected[maker] def genEngineConfig(engine: Engine, engineDir: String): Unit = {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("engine", engine)
    val mimetypes = MediaTypes.buildTypes(new Resources(None,
      List.empty, getResource("sas/mime.types")))
    data.put("mimetypes", mimetypes)
    val envTemplate = SasTool.templateCfg.getTemplate(s"${engine.typ}/conf/web.xml.ftl")
    val nsw = new StringWriter()
    envTemplate.process(data, nsw)
    Files.writeString(new File(engineDir + "/conf/web.xml"), nsw.toString)
  }

  /** 创建一个运行服务器
   * 前期检查该服务是否存在以及是否运行
   *
   * @param sasHome
   * @param container
   * @param server
   */
  def makeServer(sasHome: String, container: Container, server: Server): Unit = {
    val result = SasTool.detectExecution(server)
    result match {
      case Some(e) =>
        val dirs = Dirs.on(sasHome + "/servers/" + server.qualifiedName)
        dirs.write("SERVER_PID", e.processId.toString)
      case None =>
        doMakeBase(sasHome, container, server)
        SasTool.rollLog(sasHome, container, server)
    }
  }

  /** 生成一个base的目录结构和配置文件
   *
   * @param sasHome
   * @param container
   * @param server
   */
  protected[maker] def doMakeBase(sasHome: String, container: Container, server: Server): Unit = {
    val engine = server.farm.engine
    val serverName = server.qualifiedName
    val base = Dirs.on(sasHome + "/servers/" + serverName)
    base.mkdirs()
    base.mkdirs("temp", "work", "conf")
    //这个文件夹可能是只读，不好删除，先设置可写
    base.cd("webapps").setWriteable()
    //删除这些已有文件，创建一个新环境
    base.delete("webapps", "conf", "bin", "logs", "lib").mkdirs("webapps", "conf", "bin")

    val engineHome = engine.path(sasHome)
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

    container.getWebapps(server) foreach { w =>
      val docBase = new File(w.docBase)
      if (docBase.exists() && docBase.isFile) {
        w.unpack match {
          case Some(unpack) => if (unpack) unzipWar(base, w)
          case None =>
            w.unpack = Some(!War.isLibEmpty(w.docBase))
            if w.unpack.get then unzipWar(base, w)
        }
      }
    }
    //这个文件夹设置成只读
    base.cd("webapps").setReadOnly()
    genBaseConfig(container, server, sasHome)
  }

  protected[maker] def unzipWar(base: Dirs, webapp: Webapp): Unit = {
    var path = webapp.contextPath
    if (path.startsWith("/")) path = path.substring(1)
    if (path.endsWith("/")) path = path.substring(0, path.length - 1)
    path = path.replace("/", "#")
    if (Strings.isBlank(path)) path = "ROOT"
    val docBase = base.cd("webapps").mkdirs(path).cd(path).pwd
    Zipper.unzip(new File(webapp.docBase), docBase)
    webapp.docBase = docBase.getAbsolutePath
  }

  protected[maker] def genBaseConfig(container: Container, server: Server, targetDir: String): Unit = {
    val farm = server.farm
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    data.put("server", server)
    data.put("webapps", container.getWebapps(server))
    val sw = new StringWriter()
    val freemarkerTemplate = SasTool.templateCfg.getTemplate(s"${farm.engine.typ}/conf/server.xml.ftl")
    freemarkerTemplate.process(data, sw)
    val serverDir = targetDir + "/servers/" + server.qualifiedName
    new File(serverDir).mkdirs()
    Files.writeString(new File(serverDir + "/conf/server.xml"), sw.toString)

    val envTemplate = SasTool.templateCfg.getTemplate(s"sas/setenv.sh.ftl")
    val nsw = new StringWriter()
    envTemplate.process(data, nsw)
    new File(serverDir + "/bin").mkdirs()
    val target = new File(serverDir + "/bin/setenv.sh")
    Files.writeString(target, nsw.toString)
    target.setExecutable(true)
  }

}
