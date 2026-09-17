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

import java.util.HashMap;
import java.util.Map;

public class CmdOptions {

  public static Server.Config parse(String[] args) {
    String base = null;
    String path = "";
    int port = -1;
    boolean devMode = false;
    Map<String, String> properties = new HashMap<>();
    for (String arg : args) {
      if (arg.startsWith("--")) {
        if (arg.startsWith("--path=")) {
          path = arg.substring("--path=".length());
        } else if (arg.startsWith("--port=")) {
          port = Integer.parseInt(arg.substring("--port=".length()));
        } else if (arg.startsWith("--dev=")) {
          devMode = Boolean.parseBoolean(arg.substring("--dev=".length()));
          if (devMode) EnvProfile.enableDevMode();
        } else if (arg.startsWith("--base=")) {
          base = arg.substring("--base=".length()).trim();
        } else if (arg.startsWith("--D")) {
          //引擎属性，形如 --Dconnector.maxConnections=20000，无值(如 --Dxxx)时视为 true
          int idx = arg.indexOf('=');
          if (idx > 3) {
            properties.put(arg.substring(3, idx).trim(), arg.substring(idx + 1).trim());
          } else if (idx < 0 && arg.length() > 3) {
            properties.put(arg.substring(3).trim(), "true");
          } else {
            System.out.println("ignore param " + arg);
          }
        }
      } else {
        System.out.println("ignore param " + arg);
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

    Server.Config config = new Server.Config(Server.Config.initBase(base).getAbsolutePath(), path, port);
    config.properties.putAll(properties);
    config.devMode = devMode || EnvProfile.isDevMode();
    config.guessDocBase();
    return config;
  }

}
