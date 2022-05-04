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

package org.beangle.sas.config

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.sas.config.Proxy.{Https, Status}

import scala.collection.mutable

object Proxy {
  class Server(var name: String, var ip: String, var port: Int, var options: Option[String])

  class Backend(var name: String) {
    var options: Option[String] = None
    var servers: mutable.Buffer[Server] = Collections.newBuffer[Server]

    def addServer(name: String, ip: String, port: Int, options: Option[String]): Server = {
      require(port > 0, s"wrong port:${name} ${port}")
      getServer(name, ip) match {
        case None =>
          val newServer = new Server(name, ip, port, options)
          servers += newServer
          newServer
        case Some(s) =>
          s.port = port
          s.options = options
          s
      }
    }

    def getServer(name: String, ip: String): Option[Server] = {
      servers.find(x => x.name == name && x.ip == ip)
    }

    def contains(sname: String, ip: String): Boolean = {
      servers.exists(x => x.name == sname && x.ip == ip)
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
    var port: Int = 443
    var forceHttps: Boolean = true
  }

}

import org.beangle.sas.config.Proxy.*

class Proxy {
  /** 后端主机列表设置 */
  val backends: mutable.Buffer[Backend] = Collections.newBuffer[Backend]
  /** 代理引擎类型 */
  var engine: String = "haproxy"
  /** 主机 */
  var hostname: Option[String] = None
  /** 最大连接数 */
  var maxconn: Int = 30000
  /** http端口 */
  var httpPort: Int = 80
  /** 统计状态设置 */
  var status: Option[Status] = None
  /** https配置 */
  var https: Option[Https] = None

  def update(proxy: Proxy): Unit = {
    this.hostname = proxy.hostname
    this.maxconn = proxy.maxconn
  }

  def getBackend(pattern: String): Backend = {
    var name = pattern
    name = Strings.replace(name, ".", "_")
    backends.find(b => b.name == name).get
  }

  def addBackend(backend: Backend): Backend = {
    backends.addOne(backend)
    backend
  }

  def enableHttps: Boolean = {
    https.isDefined
  }
}
