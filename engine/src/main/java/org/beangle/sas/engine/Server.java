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

public interface Server {
  void start();

  void shutdown();

  class Config {
    public final String contextPath;
    public final String docBase;
    public final int port;
    public String hostname;
    public boolean devMode = false;
    public boolean jspSupport = false;
    public boolean defaultServletSupport = true;
    public int defaultSessionTimeout = 30;//minutes
    public String unpack = "";
    public Map<String, String> properties = new HashMap<String, String>();

    public Config(String contextPath, int port) {
      this(contextPath, port, null);
    }

    public Config(String contextPath, int port, String docBase) {
      this.contextPath = contextPath;
      this.port = port;
      this.docBase = docBase;
    }

    public boolean embedMode() {
      return null == docBase;
    }

    public Integer getInt(String propertyName) {
      String v = properties.get(propertyName);
      if (null == v || v.isEmpty()) return null;
      else return Integer.valueOf(v);
    }

    public final File createTempDir(String prefix) {
      try {
        File tempDir = Files.createTempDirectory(prefix + "." + port + ".").toFile();
        tempDir.deleteOnExit();
        return tempDir;
      } catch (IOException ex) {
        throw new RuntimeException(
          "Unable to create tempDir. java.io.tmpdir is set to " + System.getProperty("java.io.tmpdir"), ex);
      }
    }
  }

}
