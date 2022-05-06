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
import org.beangle.sas.engine.AbstractServer;

public class TomcatServer extends AbstractServer {
  private final Tomcat tomcat;

  public TomcatServer(Tomcat tomcat) {
    this.tomcat = tomcat;
  }

  @Override
  public void doStart() throws Exception {
    this.tomcat.start();
  }

  @Override
  public void doStop() throws Exception {
    tomcat.stop();
    tomcat.destroy();
  }
}
