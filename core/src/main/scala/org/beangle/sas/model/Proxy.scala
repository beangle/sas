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
package org.beangle.sas.model

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.sas.model.Proxy.{Https, Status}

import scala.collection.mutable

object Proxy {
  def getDefault: Proxy = {
    new Proxy
  }

  class Server(var name: String, var host: String, var options: Option[String])

  class Backend(var name: String) {
    var options: Option[String] = None
    var servers: mutable.Buffer[Server] = Collections.newBuffer[Server]

    def getServer(name: String): Option[Server] = {
      servers.find(_.name == name)
    }

    def addServer(name: String): Server = {
      getServer(name) match {
        case None =>
          val s = new Server(name, null, None)
          servers += s
          s
        case Some(s) => s
      }
    }

    def addServer(name: String, host: String, options: Option[String]): Unit = {
      getServer(name) match {
        case None =>
          servers += new Server(name, host, options)
        case Some(s) =>
          s.name = name
          s.host = host
          s.options = options
      }
    }

    def contains(sname: String): Boolean = {
      servers.exists(_.name == sname)
    }
  }

  class Status {
    var auth: String = "admin:ChangeItNow"
    var uri: String = "/status"
  }

  class Https {
    var certificate: String = _
    var certificateKey: String = _
    var ciphers: String = _
    var protocols: String = _
    var port = 443
    var forceHttps: Boolean = true
  }

}

import org.beangle.sas.model.Proxy._

class Proxy {
  var engine: String = "haproxy"
  /** 主机 */
  var hostname: Option[String] = None
  /** 最大连接数 */
  var maxconn: Int = 15000
  /** 统计状态设置 */
  var status: Option[Status] = None
  /** https配置 */
  var https: Option[Https] = None
  /** 后端主机列表设置 */
  val backends: mutable.Map[String, Backend] = Collections.newMap[String, Backend]

  def update(proxy: Proxy): Unit = {
    this.hostname = proxy.hostname
    this.maxconn = proxy.maxconn
  }

  def getOrCreateBackend(pattern: String, container: Container): Backend = {
    var name = pattern
    name = Strings.replace(name, ",", "_")
    name = Strings.replace(name, ".", "_")
    backends.get(name) match {
      case None =>
        val backend = new Backend(name)
        container.getMatchedServers(pattern) foreach { s => backend.addServer(s.qualifiedName) }
        addBackend(backend)
      case Some(b) =>
        if (b.servers.isEmpty) {
          container.getMatchedServers(pattern) foreach { s => b.addServer(s.qualifiedName) }
        }
        b
    }
  }

  def getBackend(pattern: String): Backend = {
    var name = pattern
    name = Strings.replace(name, ",", "_")
    name = Strings.replace(name, ".", "_")
    backends(name)
  }

  def addBackend(backend: Backend): Backend = {
    backends.put(backend.name, backend)
    backend
  }

  def enableHttps: Boolean = {
    https.isDefined
  }
}
