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
package org.beangle.sas.config.model

import java.io.File
import java.net.URL

import org.beangle.commons.lang.Strings
import org.beangle.repo.artifact.Artifact

object EngineType {
  val Tomcat = "tomcat"
}

class Engine(var name: String, var typ: String, var version: String) {
  var context: Context = _

  var jspSupport = false

  val listeners = new collection.mutable.ListBuffer[Listener]

  val jars = new collection.mutable.ListBuffer[Jar]
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
    val j = new Jar
    j.gav = Some(str)
    j
  }
}
class Jar {
  var gav: Option[String] = None
  var url: Option[String] = None
  var path: Option[String] = None

  def name: String = {
    if (gav.isDefined) {
      val a = Artifact(gav.get)
      a.artifactId + "-" + a.version + "." + a.packaging
    } else if (url.isDefined) {
      val f = new URL(url.get).getFile
      Strings.substringAfterLast(f, "/")
    } else if (path.isDefined) {
      new File(path.get).getName
    } else {
      throw new RuntimeException("Invalid jar format")
    }
  }
}
