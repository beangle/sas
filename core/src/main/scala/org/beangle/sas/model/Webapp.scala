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

class Webapp(var name: String) {

  val resources = new collection.mutable.ListBuffer[Resource]

  def resourceNames: Set[String] = resources.map(d => d.name).toSet

  var docBase: String = _

  var url: String = _

  var gav: String = _

  val properties = new java.util.Properties

  var realms: String = _

  var jspSupport: Boolean = false

  var websocketSupport: Boolean = false
}
