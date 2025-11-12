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

public class CmdOptions {

  public static Server.Config parse(String[] args) {
    String docBase = null;
    String path = "";
    int port = -1;
    boolean devMode = false;
    for (String arg : args) {
      if (arg.startsWith("--")) {
        if (arg.startsWith("--path=")) {
          path = arg.substring("--path=".length());
        } else if (arg.startsWith("--port=")) {
          port = Integer.parseInt(arg.substring("--port=".length()));
        } else if (arg.startsWith("--dev=")) {
          devMode = Boolean.parseBoolean(arg.substring("--dev=".length()));
          if (devMode) EnvProfile.enableDevMode();
        }
      } else {
        if (!arg.startsWith("-")) {
          docBase = arg;
        }
      }
    }
    if (port == -1) {
      for (int i = 0; i < 100; i++) {
        port = 8080 + i;
        if (Tools.isPortFree(port)) break;
      }
    } else {
      if (!Tools.isPortFree(port)) {
        port = -Math.abs(port);
      }
    }
    Server.Config config = new Server.Config(path, port, docBase);
    if (null != docBase) {
      if (Tools.isLibEmpty(docBase)) config.unpack = "false";
    }

    config.devMode = devMode || EnvProfile.isDevMode();
    return config;
  }

}
