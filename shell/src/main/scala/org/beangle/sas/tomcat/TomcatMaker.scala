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

import java.io.{File, FileOutputStream}
import java.net.URL

import org.beangle.commons.file.zip.Zipper
import org.beangle.commons.io.{Dirs, IOs}
import org.beangle.commons.lang.Strings.substringAfterLast
import org.beangle.commons.lang.{ClassLoaders, Strings}
import org.beangle.repo.artifact.{Artifact, ArtifactDownloader, Repo}
import org.beangle.sas.model._

object TomcatMaker {

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
      context.jarScanner = scanner
    }
    //添加beangle-sas-tomcat and logback-access
    engine.jars += Jar.gav("org.beangle.sas:beangle-sas-tomcat:" + container.version)
    engine.jars += Jar.gav("ch.qos.logback:logback-access:1.3.0-alpha5")
  }

  def makeEngine(sasHome: String, engine: Engine, remote: Repo.Remote, local: Repo.Local): Unit = {
    val tomcat = new File(sasHome + "/engines/tomcat-" + engine.version)
    // tomcat not exists or empty dir
    if (!tomcat.exists() || tomcat.list().length == 0) {
      val artifact = Artifact("org.apache.tomcat:tomcat:zip:" + engine.version)
      new ArtifactDownloader(remote, local).download(List(artifact))
      val tomcatZip = new File(local.url(artifact))
      if (tomcatZip.exists()) {
        doMakeEngine(sasHome, tomcatZip, engine)
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


  def makeServer(container: Container, farm: Farm, server: Server, sasHome: String): Unit = {
    doMakeBase(sasHome, farm.engine, server.qualifiedName)
    Gen.spawn(container, farm, server, sasHome)
  }

  protected[tomcat] def doMakeBase(sasHome: String, engine: Engine, serverName: String): Unit = {
    val dirs = Dirs.on(sasHome + "/servers/" + serverName)
    dirs.mkdirs()
    dirs.mkdirs("temp", "work", "conf")
    dirs.delete("webapps", "conf", "bin").mkdirs("webapps", "conf", "bin")

    val engineHome = sasHome + "/engines/" + engine.typ + "-" + engine.version
    if (new File(engineHome).exists()) {
      dirs.ln(engineHome + "/lib")

      val conf = dirs.cd("conf")
      Dirs.on(engineHome + "/conf").ls() foreach { cf =>
        conf.ln(engineHome + "/conf/" + cf)
      }

      val bin = dirs.cd("bin")
      Dirs.on(engineHome + "/bin").ls() foreach { f =>
        bin.ln(engineHome + "/bin/" + f)
      }
    }
    val logs = Dirs.on(sasHome + "/logs/" + serverName)
    logs.mkdirs()
    dirs.ln(new File(sasHome + "/logs/" + serverName), "logs")
  }

  protected[tomcat] def doMakeEngine(sasHome: String, tomcatZip: File, engine: Engine): Unit = {
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
      "digest.sh", "tool-wrapper.sh", "catalina.sh", "setclasspath.sh", "makebase.sh", "ciphers.sh")

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
    Gen.spawn(engine, engineDir.getAbsolutePath)
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
