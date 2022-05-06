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

import org.beangle.commons.lang.Strings
import org.beangle.sas.config.Proxy.Backend

import scala.collection.mutable

class Webapp(var uri: String) {
  val resources = new collection.mutable.ListBuffer[Resource]
  val properties = new java.util.Properties
  var resolveSupport: Boolean = true
  var docBase: String = _
  var realms: String = _
  var jspSupport: Boolean = false
  var websocketSupport: Boolean = false
  var runAt: mutable.ArrayBuffer[Server] = new mutable.ArrayBuffer[Server]
  var entryPoint: Proxy.Backend = _
  var contextPath: String = _
  var unpack: Option[Boolean] = None

  def resourceNames: Set[String] = resources.map(d => d.name).toSet

  def getContainerSciFilter(engine: Engine): Option[String] = {
    engine.typ match {
      case "tomcat" =>
        if !jspSupport && !websocketSupport then Some("apache")
        else if !jspSupport then Some("JasperInitializer")
        else if !websocketSupport then Some("WsSci")
        else None
      case _ => None
    }
  }

  def updatePath(path: String): Unit = {
    this.contextPath =
      if Strings.isEmpty(path) || path == "/" then ""
      else if path.endsWith("/") then path.substring(0, path.length - 1)
      else path
  }

  override def toString: String = {
    uri
  }

  override def hashCode(): Int = {
    uri.hashCode
  }

  override def equals(obj: Any): Boolean = {
    obj match {
      case e: Webapp => e.uri == this.uri
      case _ => false
    }
  }
}
