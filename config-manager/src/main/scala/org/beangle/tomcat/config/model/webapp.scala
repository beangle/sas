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
package org.beangle.tomcat.config.model

class Webapp {

  var base: String = "webapps"

  var contexts = new collection.mutable.ListBuffer[Context]

  def contextPaths: Set[String] = contexts.map(c => c.path).toSet
}

class Context(var path: String) {

  val dataSources = new collection.mutable.ListBuffer[DataSource]

  def dataSourceNames: Set[String] = dataSources.map(d => d.name).toSet

  var runAt: String = _

  var reloadable = false

  def name: String = if (path == "/") "ROOT" else path.substring(1)
}

class DataSource(var name: String) {

  var url: String = _

  var driver: String = _

  var username: String = _

  var password: String = _

  var driverClassName: String = _

  val properties = new collection.mutable.HashMap[String, String]
}