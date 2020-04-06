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
package org.beangle.sas.tomcat

import java.io.File
import java.nio.file.Files

object FileUtils {

  def setReadOnly(file: File): Unit = {
    if (file.exists() && file.canWrite()) {
      doSetReadOnly(file)
    }
  }

  def setWriteable(file: File): Unit = {
    if (file.exists() && !Files.isWritable(file.toPath)) {
      doSetWriteable(file)
    }
  }

  private def doSetReadOnly(file: File): Unit = {
    file.setReadOnly()
    if (file.isDirectory && !file.isHidden && !Files.isSymbolicLink(file.toPath)) {
      file.listFiles() foreach { child =>
        doSetReadOnly(child)
      }
    }
  }

  private def doSetWriteable(file: File): Unit = {
    file.setWritable(true)
    if (file.isDirectory && !file.isHidden && !Files.isSymbolicLink(file.toPath)) {
      file.listFiles() foreach { child =>
        doSetWriteable(child)
      }
    }
  }
}
