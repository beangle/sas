
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
package org.beangle.tomcat.configer.model

import org.beangle.commons.lang.Strings

object Farm {
  def build(name: String, serverCount: Int): Farm = {
    require(serverCount > 0 && serverCount <= 10, "Cannot create farm contain so much servers.")
    val farm = new Farm(name)
    Range(0, serverCount).foreach { i =>
      val server1 = new Server(farm, "server" + (i + 1), 8005 + i)
      if (null != farm.http) {
        server1.http = farm.http
        server1.httpPort = 8080 + i
      }
      if (null != farm.ajp) {
        server1.ajp = farm.ajp
        server1.ajpPort = 9009 + i
      }
      if (null != farm.https) {
        server1.https = farm.https
        server1.httpsPort = 9009 + i
      }
      farm.servers += server1
    }
    if (1 == serverCount) farm.servers.head.name = "server"
    farm.jvmopts = "-noverify -Xmx1G -Xms1G"
    farm
  }
}

class Farm(var name: String) {

  var http = new HttpConnector

  var ajp: AjpConnector = _

  var https: HttpsConnector = _

  var servers = new collection.mutable.ListBuffer[Server]

  var jvmopts: String = _
}
