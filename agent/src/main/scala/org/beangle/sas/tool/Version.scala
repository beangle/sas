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

package org.beangle.sas.tool

import java.net.URL

object Version {
  def main(args: Array[String]): Unit = {
    val version = findJarVersion(Version.getClass)
    println(org.beangle.sas.Version.logo(version))
    println(" hosts:" + SasTool.getLocalIPs().toBuffer.sorted.mkString(","))
  }

  private def findJarVersion(clazz: Class[_]): String = {
    val className = "/" + clazz.getName().replace(".", "/") + ".class"
    val classPath = clazz.getResource(className).toString
    if (classPath.startsWith("jar")) {
      val manifestPath = classPath.replace(className, "/META-INF/MANIFEST.MF")
      val manifest = new java.util.jar.Manifest(new URL(manifestPath).openStream)
      val attr = manifest.getMainAttributes
      var version = attr.getValue("Bundle-Version")
      if (null == version) {
        version = attr.getValue("Implementation-Version")
      }
      if (null == version) "UNKNOWN" else version
    } else {
      "SNAPSHOT"
    }
  }
}
