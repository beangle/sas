package org.beangle.as.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public final class Delta {

  public static void diff(String oldFile, String newFile, String diffFile) {
    exec("bsdiff", oldFile, newFile, diffFile);
  }

  public static void patch(String oldFile, String newFile, String diffFile) {
    exec("bspatch", oldFile, newFile, diffFile);
  }

  public static String sha1(String fileLoc) {
    return exec("sha1sum", fileLoc);
  }

  private static String exec(String command, String... args) {
    try {
      String[] arguments = new String[args.length + 1];
      arguments[0] = command;
      for (int i = 0; i < args.length; i++) {
        arguments[i + 1] = args[i];
      }
      ProcessBuilder pb = new ProcessBuilder(arguments);
      pb.redirectErrorStream(true);
      Process pro = pb.start();
      pro.waitFor();
      BufferedReader reader = new BufferedReader(new InputStreamReader(pro.getInputStream()));
      StringBuilder sb = new StringBuilder();
      String line = reader.readLine();
      while (line != null) {
        sb.append(line).append('\n');
        line = reader.readLine();
      }
      reader.close();
      return sb.toString();
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }
}
