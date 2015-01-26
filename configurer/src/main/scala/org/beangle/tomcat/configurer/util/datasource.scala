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
package org.beangle.tomcat.configurer.util

import org.beangle.commons.lang.Consoles.prompt
import org.beangle.data.jdbc.vendor.{ UrlFormat, Vendors }
import org.beangle.tomcat.configurer.model.Resource

object DataSourceConfig {

  def config(resource: Resource) {
//    if (null == resource.driverClassName) {
//      resource.driverClassName = Vendors.drivers.get(resource.driver) match {
//        case Some(di) => di.className
//        case None => println("cannot find driver " + resource.driver + "className"); "unknown"
//      }
//    }
    val format = new UrlFormat(resource.url)
    if (!format.params.isEmpty) {
      val params = format.params
      val values = new collection.mutable.HashMap[String, String]
      params.foreach { param => values.put(param, prompt("enter " + param + ":")) }
      resource.url = format.fill(values.toMap)
    }

    if (null == resource.username || resource.username == "<username>") {
      resource.username = prompt("enter datasource " + resource.name + " username:")
    }
  }
}