package org.beangle.sas.engine;

import java.io.File;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

public class CmdOptions {
  public static Server.Config parse(String[] args) {
    String docBase = null;
    String path = "";
    int port = 8080;
    boolean devMode = true;
    for (String arg : args) {
      if (arg.startsWith("--")) {
        if (arg.startsWith("--path=")) {
          path = arg.substring("--path=".length());
        } else if (arg.startsWith("--port=")) {
          port = Integer.parseInt(arg.substring("--port=".length()));
        } else if (arg.startsWith("--dev=")) {
          devMode = Boolean.parseBoolean(arg.substring("--dev=".length()));
        }
      } else {
        docBase = arg;
      }
    }
    Server.Config config = new Server.Config(path, port, docBase);
    if (null != docBase) {
      if (Tools.isLibEmpty(docBase)) {
        config.unpack = "false";
      }
    }
    config.devMode = devMode;
    return config;
  }

}
