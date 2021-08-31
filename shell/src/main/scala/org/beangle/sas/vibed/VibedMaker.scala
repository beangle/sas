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

package org.beangle.sas.vibed

import java.io.{File, StringWriter}

import org.beangle.commons.io.{Dirs, Files}
import org.beangle.boot.artifact.Repo
import org.beangle.sas.model.{Container, Engine, Server}
import org.beangle.sas.server.SasTool

object VibedMaker {

  def makeEngine(sasHome: String, engine: Engine, remote: Repo.Remote, local: Repo.Local): Unit = {

  }

  def makeServer(sasHome: String, container: Container, server: Server, ips: Set[String]): Unit = {
    val result = SasTool.detectExecution(server)
    result match {
      case Some(e) =>
        val dirs = Dirs.on(sasHome + "/servers/" + server.qualifiedName)
        dirs.write("SERVER_PID", e.processId.toString)
      case None =>
        doMakeBase(sasHome, container, server, ips)
        SasTool.rollLog(sasHome, container, server)
    }
  }

  private def doMakeBase(sasHome: String, container: Container, server: Server, ips: Set[String]): Unit = {
    val farm=server.farm
    val serverName = server.qualifiedName
    val serverDir = sasHome + "/servers/" + serverName
    val base = Dirs.on(sasHome + "/servers/" + serverName)
    base.mkdirs()
    base.delete("bin", "conf", "logs")
    base.mkdirs("bin", "conf")
    val logs = Dirs.on(sasHome + "/logs/" + serverName)
    logs.mkdirs()
    base.ln(new File(sasHome + "/logs/" + serverName), "logs")

    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", server.farm)
    data.put("server", server)
    data.put("ips", ips)
    data.put("deployments", container.getDeployments(server, ips))
    val sw = new StringWriter()
    val freemarkerTemplate = SasTool.templateCfg.getTemplate(s"${farm.engine.typ}/conf/server.xml.ftl")
    freemarkerTemplate.process(data, sw)
    Files.writeString(new File(serverDir + "/conf/server.xml"), sw.toString)

    container.getDeployments(server, ips) foreach { d =>
      container.getWebapp(d.webapp) foreach { w =>
        base.cd("bin").write("command.txt", w.docBase)
        Files.setExecutable(new File(w.docBase))
      }
    }

    if (farm.opts.isDefined) {
      val envTemplate = SasTool.templateCfg.getTemplate(s"sas/setenv.sh.ftl")
      val nsw = new StringWriter()
      envTemplate.process(data, nsw)
      new File(serverDir + "/bin").mkdirs()
      val target = new File(serverDir + "/bin/setenv.sh")
      Files.writeString(target, nsw.toString)
      target.setExecutable(true)
    }
  }

}
