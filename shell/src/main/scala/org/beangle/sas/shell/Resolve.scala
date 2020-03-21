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
package org.beangle.sas.shell

import java.io.{File, FileInputStream, FileOutputStream}
import java.net.URL

import org.beangle.commons.collection.Collections
import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Strings.{isEmpty, isNotEmpty, split, substringAfterLast}
import org.beangle.repo.artifact.{Artifact, ArtifactDownloader, BeangleResolver, Repo}
import org.beangle.sas.model.{Container, EngineType, Farm, Server}
import org.beangle.sas.tomcat.TomcatMaker

object Resolve {

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      println("Usage: Resolve /path/to/server.xml server_name")
      return
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    container.engines foreach { engine =>
      if (engine.typ == EngineType.Tomcat) {
        TomcatMaker.applyEngineDefault(container, engine)
      }
    }
    val server = args(1)
    val sasHome = configFile.getParentFile.getParentFile.getCanonicalPath

    resolve(container, sasHome, server)
  }

  def resolve(container: Container, sasHome: String, serverName: String): Unit = {
    val repository = container.repository

    val remote =
      if (repository.remote.isEmpty) new Repo.Remote("remote", Repo.Remote.AliyunURL)
      else new Repo.Remote("remote", repository.remote.get)

    val local = new Repo.Local(repository.local.orNull)

    container.engines foreach { engine =>
      if (engine.typ == "tomcat") {
        TomcatMaker.makeEngine(sasHome, engine, remote, local)
      } else {
        System.err.println("Cannot recoganize engine type " + engine.typ)
        System.exit(1)
      }
    }

    container.webapps foreach { webapp =>
      if (isEmpty(webapp.docBase)) {
        if (isNotEmpty(webapp.url)) {
          val fileName = download(webapp.url, sasHome + "/webapps/")
          webapp.docBase = sasHome + "/webapps/" + fileName
        } else if (isNotEmpty(webapp.gav)) {
          val gavinfo = split(webapp.gav, ":")
          if (gavinfo.length < 3) throw new RuntimeException(s"Invalid gav ${webapp.gav},Using groupId:artifactId:version format.")
          val old = Artifact(webapp.gav)
          val war = Artifact(old.groupId, old.artifactId, old.version, old.classifier, "war")
          new ArtifactDownloader(remote, local).download(List(war))
          webapp.docBase = local.url(war)
        } else {
          throw new RuntimeException(s"Invalid Webapp definition ${webapp.name},one of (docBase,url,gav) properties needed.")
        }
      } else {
        if (webapp.docBase.contains("${sas.home}")) {
          webapp.docBase = webapp.docBase.replace("${sas.home}", sasHome)
        } else if (webapp.docBase.startsWith("../../..")) {
          webapp.docBase = webapp.docBase.replace("../../..", sasHome)
        }
      }

      //解析轻量级war
      val libs = BeangleResolver.resolve(webapp.docBase)
      new ArtifactDownloader(remote, local).download(libs)
      val missing = libs filter (!local.exists(_))
      if (missing.nonEmpty) {
        System.err.println("Download error :" + missing)
        System.err.println("Cannot launch webapp :" + webapp.docBase)
      }
    }

    //last step
    container.farms foreach { farm =>
      if (farm.name == serverName || serverName == "all") {
        for (server <- farm.servers) {
          makeServer(container, farm, server, sasHome)
        }
      } else {
        farm.servers foreach { server =>
          if (serverName == server.qualifiedName) {
            makeServer(container, farm, server, sasHome)
          }
        }
      }
    }
  }

  private def makeServer(container: Container, farm: Farm, server: Server, sasHome: String): Unit = {
    val deployments = container.getDeployments(server)
    if (deployments.isEmpty) {
      println(s"Due to zero deployments,${server.qualifiedName}'s launch was aborted.")
    } else {
      val missingWars = Collections.newBuffer[String]
      val appDocBases = container.webapps.map { x => x.name -> x.docBase }.toMap
      deployments foreach { deployment =>
        val docBase = appDocBases(deployment.webapp)
        if (!new File(docBase).exists()) {
          missingWars += docBase
        }
      }
      if (missingWars.nonEmpty) {
        println(s"Due to missing wars ${missingWars},${server.qualifiedName}'s launch was aborted.")
      } else {
        TomcatMaker.makeServer(container, farm, server, sasHome)
        TomcatMaker.rollLog(container, server, sasHome)
      }
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
