package org.beangle.sas.engine;

import java.io.File;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class Tools {
  public static boolean isLibEmpty(String path) {
    File file = new File(path);
    if (file.exists()) {
      try {
        ZipFile war = new ZipFile(file);
        Enumeration<? extends ZipEntry> entries = war.entries();
        boolean finded = false;
        while (entries.hasMoreElements() && !finded) {
          String entry = entries.nextElement().getName();
          finded = (entry.startsWith("WEB-INF/lib/") && entry.endsWith(".jar"));
        }
        return !finded;
      } catch (Exception e) {
        throw new RuntimeException("Cannot unzip war file located at " + path);
      }
    } else {
      throw new RuntimeException("Cannot find war file located at " + path);
    }
  }
}
