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
import org.beangle.sas.engine.Desktops;
import org.beangle.sas.engine.Server;
import org.beangle.sas.engine.Tools;

import java.io.File;
import java.util.logging.Logger;

public class Bootstrap {

  private static Logger logger = Logger.getLogger(Bootstrap.class.toString());

  public static void main(String[] args) {
    var startAt = System.currentTimeMillis();
    Server.Config config = CmdOptions.parse(args);
    if (config.port < 0) {
      logger.severe("port " + Math.abs(config.port) + " is not available.");
      return;
    }
    File baseDir = config.createTempDir("tomcat");
    logger.info("create base dir: " + baseDir.getAbsolutePath());
    new File(baseDir, "webapps").mkdirs();
    Tomcat tomcat = new TomcatServerBuilder(config).build(baseDir.getAbsolutePath());
    final TomcatServer ts = new TomcatServer(tomcat);
    ts.start();
    var duration = (System.currentTimeMillis() - startAt) / 1000.0;
    var url = "http://localhost:" + config.port + config.contextPath;
    logger.info("Tomcat started(" + duration + "s):" + url);
    Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
      @Override
      public void run() {
        ts.shutdown();
        Tools.delete(baseDir);
      }
    }));
    Desktops.openBrowser(url);
  }

}
