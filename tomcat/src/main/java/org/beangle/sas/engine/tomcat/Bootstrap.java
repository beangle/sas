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

package org.beangle.sas.engine.tomcat;

import org.apache.catalina.startup.Tomcat;
import org.beangle.sas.engine.CmdOptions;
import org.beangle.sas.engine.Server;

public class Bootstrap {
  public static void main(String[] args) {
    if (args.length < 1) {
      System.out.println("Usage:org.beangle.sas.engine.tomcat.Bootstrap [--port=8081] [--path=/test] /path/to/your/war");
      return;
    }
    Server.Config config = CmdOptions.parse(args);
    Tomcat tomcat = new TomcatServerBuilder(config).build();
    final TomcatServer ts = new TomcatServer(tomcat);
    ts.start();
    Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
      @Override
      public void run() {
        ts.shutdown();
      }
    }));
  }
}
