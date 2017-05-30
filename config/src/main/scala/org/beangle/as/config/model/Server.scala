
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
package org.beangle.as.config.model

import org.beangle.commons.lang.Strings

class Server(val farm: Farm, var name: String, var shutdownPort: Int) {

  var jvmopts: String = _

  var httpPort: Int = _

  var httpsPort: Int = _

  var ajpPort: Int = _

  var http = new HttpConnector

  var ajp: AjpConnector = _

  var https: HttpsConnector = _

  def qualifiedName: String = {
    if (Strings.isNotBlank(farm.name)) farm.name + "." + name
    else name
  }
  def port(http: Int, https: Int = 0, ajp: Int = 0): this.type = {
    require(http >= 80, "http port should >= 80")
    require(https == 0 || https >= 443, "https port should >=443")
    require(ajp == 0 || ajp >= 1024, "ajp port should >=1024")
    if (https > 0)
      require(http != https, "http port should not equals https port")
    if (ajp > 0)
      require(http != ajp && ajp != https, "ajpport should not equals  http and https port")
    httpPort = http
    httpsPort = https
    ajpPort = ajp
    this
  }
}