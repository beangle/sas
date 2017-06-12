/*
 * Beangle, Agile Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2017, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.config.util

import java.io.File
import org.beangle.commons.io.Files
import java.nio.file.Paths
import org.beangle.commons.io.IOs

object Dirs {

  def on(path: String): Dirs = {
    new Dirs(new File(path))
  }

  def on(file: File): Dirs = {
    new Dirs(file)
  }
  def on(file: File, child: String): Dirs = {
    new Dirs(new File(file, child))
  }

  def delete(file: File): Unit = {
    if (file.exists()) remove(file)
  }

  private def remove(file: File): Unit = {
    if (file.exists()) {
      if (file.isDirectory()) {
        if (file.list().length == 0) {
          file.delete()
        } else {
          //list all the directory contents
          val files = file.list()
          var i = 0
          while (i < files.length) {
            val tmp = files(i)
            remove(new File(file, tmp))
            i += 1
          }
          if (file.list().length == 0) file.delete()
        }
      } else {
        file.delete()
      }
    }
  }
}

class Dirs(val pwd: File) {
  def delete(children: String*): this.type = {
    children foreach { child =>
      Dirs.delete(new File(pwd, child))
    }
    this
  }

  def mkdirs(children: String*): this.type = {
    if (children.isEmpty) {
      pwd.mkdirs()
    } else {
      children foreach { child =>
        new File(pwd, child).mkdirs()
      }
    }
    this
  }

  def ls(): Seq[String] = {
    pwd.list().toSeq
  }
  def cd(child: String): Dirs = {
    new Dirs(new File(pwd, child))
  }

  def touch(child: String): this.type = {
    val file = new File(pwd, child)
    if (!file.exists()) {
      file.getParentFile.mkdirs()
      Files.touch(file)
    }
    this
  }

  def ln(target: String): this.type = {
    ln(new File(target))
  }

  def ln(target: File): this.type = {
    val link = new File(pwd, target.getName)
    if (link.exists()) {
      if (java.nio.file.Files.isSymbolicLink(Paths.get(link.toURI))) {
        link.delete()
        java.nio.file.Files.createSymbolicLink(Paths.get(link.toURI), Paths.get(target.toURI))
      } else {
        throw new RuntimeException("Cannot make link on existed file.")
      }
    } else {
      if (!target.exists()) throw new RuntimeException("Cannot find target " + target.getAbsolutePath)
      java.nio.file.Files.createSymbolicLink(Paths.get(link.toURI), Paths.get(target.toURI))
    }
    this
  }

  def write(fileName: String, content: String): this.type = {
    touch(fileName)
    Files.writeString(new File(pwd, fileName), content)
    this
  }

  def copyFrom(file: String): this.type = {
    val src = new File(file)
    Files.copy(src, new File(pwd, src.getName))
    this
  }
}
