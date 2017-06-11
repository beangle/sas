package org.beangle.sas.config.util

import java.io.FileOutputStream
import java.util.zip.ZipInputStream
import java.io.IOException
import java.util.zip.ZipEntry
import java.io.File
import java.io.FileInputStream
import java.io.FileInputStream

object Zipper {
  def unzip(zipFile: File, folder: File) {
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
