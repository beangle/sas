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
import org.beangle.repo.artifact.Repo
import org.beangle.sas.model.{Container, Farm, Server}
import org.beangle.sas.tomcat.TomcatMaker

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

    Resolver.resolve(sasHome, container, remote, local)
    container.engines foreach { engine =>
      if (engine.typ == "tomcat") {
        TomcatMaker.applyEngineDefault(container, engine)
        TomcatMaker.makeEngine(sasHome, engine, remote, local)
      } else {
        System.err.println("Cannot recoganize engine type " + engine.typ)
        System.exit(1)
      }
    }
    //last step
    container.farms foreach { farm =>
      for (server <- farm.servers) {
        if (serverPattern == "all" || serverPattern == farm.name || serverPattern == server.qualifiedName) {
          makeServer(sasHome, container, farm, server)
        }
      }
    }
  }

  /** 检查部署在server上的应用是否都已经存在了，如果存在则生成Server。
   * @param sasHome
   * @param container
   * @param farm
   * @param server
   */
  private def makeServer(sasHome: String, container: Container, farm: Farm, server: Server): Unit = {
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
        missingWars foreach { mw =>
          println(s"Missing ${mw}")
        }
        if (missingWars.size == 1) {
          println(s"""Due to missing a war,${server.qualifiedName}'s launch was aborted.""")
        } else {
          println(s"""Due to missing ${missingWars.size} wars,${server.qualifiedName}'s launch was aborted.""")
        }
      } else {
        TomcatMaker.makeServer(sasHome, container, farm, server)
      }
    }
  }

}
