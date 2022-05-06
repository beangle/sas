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

package org.beangle.sas.tool

import org.beangle.boot.artifact.Repo
import org.beangle.commons.collection.Collections
import org.beangle.commons.io.Dirs
import org.beangle.sas.config.{Container, Engine, EngineType, Server}
import org.beangle.sas.maker.{TomcatMaker, VibedMaker}

import java.io.{File, FileInputStream}

object Maker {

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      println("Usage: Make /path/to/server.xml server_name")
      return
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    val serverPattern = args(1)
    val sasHome = configFile.getParentFile.getParentFile.getCanonicalPath
    make(container, sasHome, serverPattern)

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
      for (server <- farm.servers; if ips.contains(server.host.ip)) {
        if (serverPattern == "all" || serverPattern == farm.name || serverPattern == server.qualifiedName) {
          servers += server
          engines += farm.engine
        }
      }
    }
    //2. resolve server webapps
    val missings = servers.map(s => s -> Resolver.resolve(sasHome, remote, local, container.getWebapps(s))).toMap

    //make engine and servers
    engines foreach { engine =>
      engine.typ match {
        case EngineType.Tomcat =>
          TomcatMaker.applyEngineDefault(container, engine)
          TomcatMaker.makeEngine(sasHome, engine, remote, local)
        case EngineType.Vibed =>
          VibedMaker.makeEngine(sasHome, engine, remote, local)
        case _ =>
          System.err.println("Cannot recognize engine type " + engine.typ)
          System.exit(1)
      }
    }
    //last step
    servers foreach { server =>
      val dirs = Dirs.on(sasHome + "/servers/" + server.qualifiedName)
      if missings(server).nonEmpty then
        dirs.write("error", missings(server).mkString("\n"))
        println(s"Cannot resolve ${server.qualifiedName},see details: ${new File(dirs.pwd, "error")}")
      else
        makeServer(sasHome, container, server)
        dirs.delete("error")
    }
  }

  /** 检查部署在server上的应用是否都已经存在了，如果存在则生成Server。
   *
   * @param sasHome
   * @param container
   * @param server
   */
  private def makeServer(sasHome: String, container: Container, server: Server): Unit = {
    val webapps = container.getWebapps(server)

    if (webapps.isEmpty) {
      //如果发现没有对应部署的webapp，并且没有运行的server，则进行删除。
      if (new File(sasHome + "/servers/" + server.qualifiedName).exists() && SasTool.detectExecution(server).isEmpty) {
        val base = Dirs.on(sasHome + "/servers")
        base.cd(server.qualifiedName + "/webapps").setWriteable()
        base.delete(server.qualifiedName)
      }
    } else {
      server.farm.engine.typ match {
        case EngineType.Tomcat => TomcatMaker.makeServer(sasHome, container, server)
        case EngineType.Vibed => VibedMaker.makeServer(sasHome, container, server)
        case _ =>
      }
    }
  }

}
