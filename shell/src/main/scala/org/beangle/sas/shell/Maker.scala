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

import java.io.{File, FileInputStream}

import org.beangle.commons.collection.Collections
import org.beangle.commons.io.Dirs
import org.beangle.repo.artifact.Repo
import org.beangle.sas.model.{Container, Engine, EngineType, Server}
import org.beangle.sas.server.SasTool
import org.beangle.sas.tomcat.TomcatMaker
import org.beangle.sas.vibed.VibedMaker

object Maker {

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      println("Usage: Make /path/to/server.xml server_name")
      return
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    val server = args(1)
    val sasHome = configFile.getParentFile.getParentFile.getCanonicalPath
    make(container, sasHome, server)
  }

  def make(container: Container, sasHome: String, serverPattern: String): Unit = {
    val repository = container.repository
    val remote =
      if (repository.remote.isEmpty) new Repo.Remote("remote", Repo.Remote.AliyunURL)
      else new Repo.Remote("remote", repository.remote.get)
    val local = new Repo.Local(repository.local.orNull)

    //1. catch ips servers and engines
    val ips = SasTool.getLocalIPs()
    val engines = Collections.newSet[Engine]
    val servers = Collections.newBuffer[Server]
    container.farms foreach { farm =>
      for (server <- farm.servers) {
        if (serverPattern == "all" || serverPattern == farm.name || serverPattern == server.qualifiedName) {
          servers += server
          engines += farm.engine
        }
      }
    }
    //2. resolve server webapps
    servers foreach { server =>
      Resolver.resolve(sasHome, container, remote, local, container.getWebapps(server, ips))
    }

    //make engine and servers
    engines foreach { engine =>
      engine.typ match {
        case EngineType.Tomcat =>
          TomcatMaker.applyEngineDefault(container, engine)
          TomcatMaker.makeEngine(sasHome, engine, remote, local)
        case EngineType.Vibed =>
          VibedMaker.makeEngine(sasHome, engine, remote, local)
        case _ =>
          System.err.println("Cannot recoganize engine type " + engine.typ)
          System.exit(1)
      }
    }
    //last step
    servers foreach { server =>
      makeServer(sasHome, container, server, ips)
    }
  }

  /** 检查部署在server上的应用是否都已经存在了，如果存在则生成Server。
   * @param sasHome
   * @param container
   * @param server
   */
  private def makeServer(sasHome: String, container: Container, server: Server, ips: Set[String]): Unit = {
    val deployments = container.getDeployments(server, ips)

    if (deployments.isEmpty) {
      //如果发现没有对应部署的，并且没有运行的server，则进行删除。
      if (new File(sasHome + "/servers/" + server.qualifiedName).exists() &&
        SasTool.detectExecution(server).isEmpty) {
        val base = Dirs.on(sasHome + "/servers")
        base.cd(server.qualifiedName + "/webapps").setWriteable()
        base.delete(server.qualifiedName)
      }
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
        missingWars foreach { mw =>
          println(s"Missing ${mw}")
        }
        if (missingWars.size == 1) {
          println(s"""Due to missing a webapp,${server.qualifiedName}'s launch was aborted.""")
        } else {
          println(s"""Due to missing ${missingWars.size} webapps,${server.qualifiedName}'s launch was aborted.""")
        }
      } else {
        server.farm.engine.typ match {
          case EngineType.Tomcat => TomcatMaker.makeServer(sasHome, container, server, ips)
          case EngineType.Vibed => VibedMaker.makeServer(sasHome, container, server, ips)
          case _ =>
        }
      }
    }
  }

}
