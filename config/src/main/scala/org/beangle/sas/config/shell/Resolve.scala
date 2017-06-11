package org.beangle.sas.config.shell

import java.io.{ File, FileInputStream, FileOutputStream }
import java.net.URL

import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Strings
import org.beangle.commons.lang.Strings.{ isEmpty, isNotEmpty, split, substringAfterLast }
import org.beangle.maven.artifact.{ Artifact, ArtifactDownloader, Repo }
import org.beangle.sas.config.model.Container
import org.beangle.sas.config.util.{ Dirs, Template, Zipper }
import org.beangle.sas.config.model.Engine
import org.beangle.sas.config.model.Farm
import org.beangle.sas.config.model.Server
import org.beangle.commons.io.Files
import org.beangle.commons.lang.ClassLoaders
import org.beangle.sas.config.model.Jar

object Resolve {

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      println("Usage: Resolve /path/to/server.xml server_name")
      return
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    val server = args(1)
    val sasHome = configFile.getParentFile.getParentFile.getCanonicalPath

    resolve(container, sasHome, server)
  }

  def resolve(container: Container, sasHome: String, serverName: String) {
    val repository = container.repository

    val remote =
      if (repository.remote.isEmpty) new Repo.Remote("remote", Repo.Remote.AliyunURL)
      else new Repo.Remote("remote", repository.remote.get)

    val local = new Repo.Local(repository.local.orNull)

    container.engines foreach { engine =>
      if (engine.typ == "tomcat") {
        val tomcat = new File(sasHome + "/engines/tomcat-" + engine.version)
        if (!tomcat.exists() || tomcat.list().length == 0) {
          val artifact = Artifact("org.apache.tomcat:tomcat:" + engine.version + ":zip")
          new ArtifactDownloader(remote, local).download(List(artifact))
          val tomcatZip = new File(local.url(artifact))
          if (tomcatZip.exists()) {
            makeTomcatEngine(sasHome, tomcatZip)
          } else {
            System.out.println("Cannot download " + artifact)
          }
        }

        engine.jars += Jar.gav("org.beangle.sas:beangle-sas-core:" + container.version)
        engine.jars foreach { jar =>
          val jarName = jar.name
          if (!new File(tomcat, "/lib/" + jarName).exists()) {
            if (jar.url.isDefined) {
              val fileName = download(jar.url.get, tomcat.getAbsolutePath + "/lib")
            } else if (jar.gav.isDefined) {
              val artifact = Artifact(jar.gav.get)
              new ArtifactDownloader(remote, local).download(List(artifact))
              Dirs.on(tomcat, "lib").ln(local.url(artifact))
            } else if (jar.path.isDefined) {
              Dirs.on(tomcat, "lib").copyFrom(jar.path.get)
            }
          }
        }
      } else {
        System.err.println("Cannot recoganize engine type " + engine.typ)
        System.exit(1)
      }
    }

    container.webapps foreach { webapp =>
      if (isEmpty(webapp.docBase)) {
        if (isNotEmpty(webapp.url)) {
          val fileName = download(webapp.url, sasHome + "/webapps/")
          webapp.docBase = "../../../webapps/" + fileName
        } else if (isNotEmpty(webapp.gav)) {
          val gavinfo = split(webapp.gav, ":")
          if (gavinfo.length < 3) throw new RuntimeException(s"Invalid gav ${webapp.gav},Using groupId:artifactId:version format.")
          val artifact = Artifact(webapp.gav + ":war")
          new ArtifactDownloader(remote, local).download(List(artifact))
          webapp.docBase = local.url(artifact)
        } else {
          throw new RuntimeException(s"Invalid Webapp definition ${webapp.name},one of (docBase,url,gav) properties needed.")
        }
      } else {
        if (webapp.docBase.contains("${sas.home}")) {
          webapp.docBase = webapp.docBase.replace("${sas.home}", "../..")
        }
      }
    }

    //last step
    container.farms foreach { farm =>
      if (farm.name == serverName || serverName == "all") {
        for (server <- farm.servers) {
          makeTomcatServer(container, farm, server, sasHome)
        }
      } else {
        farm.servers foreach { server =>
          if (serverName == server.qualifiedName) makeTomcatServer(container, farm, server, sasHome)
        }
      }
    }
  }

  def makeTomcatServer(container: Container, farm: Farm, server: Server, sasHome: String): Unit = {
    makeTomcatBase(sasHome, farm.engine, server.qualifiedName)
    Template.generate(container, farm, server, sasHome)
  }

  def makeTomcatBase(sasHome: String, engine: Engine, serverName: String): Unit = {
    val dirs = Dirs.on(sasHome + "/servers/" + serverName)
    dirs.mkdirs()
    dirs.mkdirs("temp", "work", "logs", "conf")
    dirs.touch("logs/catalina.out")
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
  }

  def makeTomcatEngine(sasHome: String, tomcatZip: File): Unit = {
    val engineHome = new File(sasHome + "/engines")
    engineHome.mkdirs()
    val tomcatDirname = tomcatZip.getName.replace(".zip", "")
    val version = Strings.substringAfterLast(tomcatDirname, "-")
    val engineDir = new File(engineHome + "/tomcat-" + version)
    if (engineDir.exists()) {
      Dirs.delete(engineDir)
    }
    Zipper.unzip(tomcatZip, engineHome)
    new File(engineHome + "/apache-tomcat-" + version).renameTo(engineDir)
    Dirs.on(engineDir).delete("work", "webapps", "logs", "temp", "RUNNING.txt")
      .delete("NOTICE", "LICENSE", "RELEASE-NOTES")

    val conf = Dirs.on(engineDir, "conf").delete("server.xml", "tomcat-users.xml", "tomcat-users.xsd",
      "jaspic-providers.xml", "jaspic-providers.xsd")

    Set("catalina.properties", "logging.properties") foreach { f =>
      ClassLoaders.getResourceAsStream("tomcat/conf/" + f) foreach { fi =>
        conf.write(f, IOs.readString(fi))
      }
    }

    Dirs.on(engineDir, "bin").delete("startup.sh", "shutdown.sh", "configtest.sh", "version.sh",
      "digest.sh", "tool-wrapper.sh", "catalina.sh", "setclasspath.sh")

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
