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
    private static boolean isTempBase = false;
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
      this.contextPath = normalizePath(contextPath);
      this.port = port;
    }

    public static String normalizePath(String p) {
      if (p == null || p.equals("/")) return "";
      else {
        String path = p;
        if (!path.startsWith("/")) path = "/" + path;
        if (path.endsWith("/")) path = path.substring(0, path.length() - 1);
        path = path.replaceAll("//", "/");
        return path;
      }
    }

    public Integer getInt(String propertyName) {
      String v = properties.get(propertyName);
      if (null == v || v.isEmpty()) return null;
      else return Integer.valueOf(v);
    }

    public Boolean getBoolean(String propertyName) {
      String v = properties.get(propertyName);
      if (null == v || v.isEmpty()) return null;
      else return Boolean.valueOf(v);
    }

    public int getInt(String propertyName, int defaultValue) {
      String v = properties.get(propertyName);
      if (null == v || v.isEmpty()) return defaultValue;
      else return Integer.parseInt(v);
    }

    public String getDefaultDocBase() {
      if (contextPath.isEmpty() || contextPath.equals("/")) {
        return base + "/webapps/ROOT";
      } else {
        return base + "/webapps/" + contextPath.substring(1).replace('/', '#');
      }
    }

    public static boolean isNativeImage() {
      return System.getProperty("org.graalvm.nativeimage.imagecode") != null;
    }

    public static File initBase(String base) {
      var logger = Logger.getLogger(Server.class.toString());
      try {
        File baseDir = null;
        if (null == base) {
          baseDir = Files.createTempDirectory("sas").toFile();
          logger.info("create base dir: " + baseDir.getAbsolutePath());
          baseDir.deleteOnExit();
          isTempBase = true;
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

    public void guessDocBase() {
      // native 模式下无法通过 getResource("").getFile() 探测 IDE 路径
      if (isNativeImage()) {
        this.docBase = this.getDefaultDocBase();
        new File(this.docBase).mkdirs();
        return;
      }
      var loader = Thread.currentThread().getContextClassLoader();
      //是否处于IDE开发环境
      var resource = loader.getResource("");
      if (resource != null) {
        String targetClassPath = resource.getFile();
        int targetIdx = targetClassPath.indexOf("/target/");
        if (targetIdx > 0) {
          String projectWebapp = targetClassPath.substring(0, targetIdx) + "/src/main/webapp";
          if (new File(projectWebapp).exists()) {
            this.docBase = projectWebapp;
          }
        }
      }
      if (null == this.docBase) {
        this.docBase = this.getDefaultDocBase();
      }
      new File(this.docBase).mkdirs();
    }

    public void cleanup() {
      if (null != docBase) {
        var dir = docBase;
        dir = dir.replace('\\', '/');
        if (docBase.startsWith(base) && !dir.contains("src/main/webapp")) {
          Tools.delete(new File(docBase));
        }
        if (isTempBase) {
          Tools.delete(new File(base));
        }
      }
    }

  }
}
