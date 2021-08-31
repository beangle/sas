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

package org.beangle.sas.model

class Webapp(var name: String) {

  var resolveSupport:Boolean=true

  val resources = new collection.mutable.ListBuffer[Resource]

  def resourceNames: Set[String] = resources.map(d => d.name).toSet

  var uri: String = _

  var docBase:String =_

  val properties = new java.util.Properties

  var realms: String = _

  var jspSupport: Boolean = false

  var websocketSupport: Boolean = false

  def getContainerSciFilter(engine: Engine): Option[String] = {
    engine.typ match {
      case "tomcat" =>
        if (!jspSupport && !websocketSupport) {
          Some("apache")
        } else if (!jspSupport) {
          Some("JasperInitializer")
        } else if (!websocketSupport) {
          Some("WsSci")
        } else {
          None
        }
      case _ => None
    }
  }

  override def toString: String = {
    name
  }

  override def hashCode(): Int = {
    name.hashCode
  }

  override def equals(obj: Any): Boolean = {
    obj match {
      case e: Webapp => e.name == this.name
      case _ => false
    }
  }
}
