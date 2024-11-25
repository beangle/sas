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
import org.beangle.commons.net.Networks

import java.io.File

object EngineType {
  val Tomcat = "tomcat"
  val Undertow = "undertow"
  val Jetty = "jetty"
  val Vibed = "vibed"
  val Any = "any"
}

class Engine(var name: String, var typ: String, var version: String) {
  val listeners = new collection.mutable.ListBuffer[Listener]
  val jars = new collection.mutable.ListBuffer[Jar]
  var context: Context = _
  var jspSupport = false

  override def toString: String = {
    name
  }

  override def hashCode(): Int = {
    name.hashCode
  }

  override def equals(obj: Any): Boolean = {
    obj match {
      case e: Engine => e.name == this.name
      case _ => false
    }
  }

  def dir(sasHome: String): File = {
    new File(path(sasHome))
  }

  def path(sasHome: String): String = {
    s"$sasHome/engines/${name}-${version}"
  }
}

class Listener(val className: String) {

  var properties = new collection.mutable.HashMap[String, String]

  def property(name: String, value: String): this.type = {
    properties.put(name, value)
    this
  }
}

class Context {
  var loader: Loader = _
  var jarScanner: JarScanner = _
}

class Loader(var className: String) {
  var properties = new collection.mutable.HashMap[String, String]
}

class JarScanner {
  var properties = new collection.mutable.HashMap[String, String]
}

object Jar {
  def gav(str: String): Jar = {
    if (str.startsWith(ArchiveURI.GavProtocol)) new Jar(str) else new Jar(ArchiveURI.GavProtocol + str)
  }
}

class Jar(val uri: String) {
  def name: String = {
    if (ArchiveURI.isGav(uri)) {
      val a = ArchiveURI.toArtifact(uri)
      a.artifactId + "-" + a.version + "." + a.packaging
    } else if (ArchiveURI.isRemote(uri)) {
      val f = Networks.url(uri).getFile
      Strings.substringAfterLast(f, "/")
    } else {
      new File(uri).getName
    }
  }
}
