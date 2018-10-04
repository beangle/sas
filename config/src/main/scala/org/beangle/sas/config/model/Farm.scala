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
/*
 * Beangle, Agile Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2014, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.config.model

import org.beangle.commons.lang.Strings

object Farm {
  def build(name: String, engine: Engine, serverCount: Int): Farm = {
    require(serverCount > 0 && serverCount <= 10, "Cannot create farm contain so much servers.")
    val farm = new Farm(name, engine)
    Range(0, serverCount).foreach { i =>
      val server1 = new Server(farm, "server" + (i + 1))
      if (null != farm.http) {
        server1.http = 8080 + i
      }
      farm.servers += server1
    }
    if (1 == serverCount) farm.servers.head.name = "server"
    farm.jvmopts = Some("-noverify -Xmx1G -Xms1G")
    farm
  }
}

class Farm(var name: String, var engine: Engine) {

  var http = new HttpConnector

  var http2: Http2Connector = _

  var servers = new collection.mutable.ListBuffer[Server]

  var jvmopts: Option[String] = None
}

class Server(val farm: Farm, var name: String) {

  /** http/1 端口*/
  var http: Int = _

  /** http/2 端口*/
  var http2: Int = _

  var host: Option[String] = None

  def qualifiedName: String = {
    if (Strings.isNotBlank(farm.name)) farm.name + "." + name
    else name
  }

  def port(http: Int): this.type = {
    require(http >= 80, "http port should >= 80")
    this.http = http
    this
  }
}
