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

package org.beangle.sas.engine;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

public interface Server {
  void start();

  void shutdown();

  class Config {
    public final String base;
    public final String contextPath;
    public final int port;
    public boolean devMode = false;
    public boolean defaultServletSupport = true;
    public int defaultSessionTimeout = 30;//minutes
    public Map<String, String> properties = new HashMap<String, String>();
    public String docBase;

    public Config(String base, String contextPath, int port) {
      this.base = base;
      this.contextPath = contextPath;
      this.port = port;
    }

    public Integer getInt(String propertyName) {
      String v = properties.get(propertyName);
      if (null == v || v.isEmpty()) return null;
      else return Integer.valueOf(v);
    }

    public String getDefaultDocBase() {
      if (contextPath.isEmpty() || contextPath.equals("/")) {
        return base + "/webapps/ROOT";
      } else {
        return base + "/webapps/" + contextPath.substring(1).replace('/', '#');
      }
    }

    public static File initBase(String base) {
      var logger = Logger.getLogger(Server.class.toString());
      try {
        File baseDir = null;
        if (null == base) {
          baseDir = Files.createTempDirectory("sas").toFile();
          logger.info("create base dir: " + baseDir.getAbsolutePath());
          baseDir.deleteOnExit();
        } else {
          baseDir = new File(base);
          baseDir.mkdirs();
        }
        new File(baseDir, "webapps").mkdirs();
        new File(baseDir, "temp").mkdirs();
        return baseDir;
      } catch (IOException ex) {
        throw new RuntimeException("Unable to create baseDir. java.io.tmpdir is set to " + System.getProperty("java.io.tmpdir"), ex);
      }
    }

    public void cleanup() {
      if (null != docBase) {
        var dir = docBase;
        dir = dir.replace('\\', '/');
        if (docBase.startsWith(base) && !dir.contains("src/main/webapp")) {
          Tools.delete(new File(docBase));
        }
      }
    }

  }
}
