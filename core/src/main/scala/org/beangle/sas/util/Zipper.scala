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
package org.beangle.sas.util

import java.io.{File, FileInputStream, FileOutputStream}
import java.util.zip.ZipInputStream

object Zipper {
  def unzip(zipFile: File, folder: File): Unit = {
    val outputFolder = folder.getAbsolutePath
    val buffer = new Array[Byte](1024)
    if (!folder.exists()) folder.mkdirs()
    val zis = new ZipInputStream(new FileInputStream(zipFile))
    var ze = zis.getNextEntry()
    while (ze != null) {
      val fileName = ze.getName()
      val newFile = new File(outputFolder + File.separator + fileName)
      if (ze.isDirectory()) {
        newFile.mkdirs()
      } else {
        new File(newFile.getParent()).mkdirs()
        val fos = new FileOutputStream(newFile)
        var len = zis.read(buffer)
        while (len > 0) {
          fos.write(buffer, 0, len)
          len = zis.read(buffer)
        }
        fos.close()
      }
      ze = zis.getNextEntry()
    }
    zis.closeEntry()
    zis.close()
  }
}
