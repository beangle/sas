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

package org.beangle.sas.tomcat.juli;

import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.joran.JoranConfigurator;
import ch.qos.logback.classic.spi.Configurator;
import ch.qos.logback.core.joran.spi.JoranException;
import ch.qos.logback.core.spi.ContextAwareBase;
import ch.qos.logback.core.status.InfoStatus;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

public class SLF4JConfigurator extends ContextAwareBase implements Configurator {

  @Override
  public void configure(LoggerContext lc) {
    JoranConfigurator configurator = new JoranConfigurator();
    configurator.setContext(lc);
    try {
      String confProperty = System.getProperty("juli.logback.configurationFile");
      String catalinaBase = System.getProperty("catalina.base");

      URL url = null;
      if (null == confProperty) {
        if (null != catalinaBase) {
          File confFile = new File(catalinaBase + "/conf/logback-catalina.xml");
          if (confFile.exists()) {
            url = confFile.toURI().toURL();
          }
        }
        if (null == url) {
          url = getClass().getClassLoader().getResource("logback-catalina.xml");
        }
        if (null == url) {
          throw new RuntimeException("Cannot load logback-catalina.xml");
        }
      } else {
        if (new File(confProperty).exists()) {
          url = new File(confProperty).toURI().toURL();
        } else {
          throw new RuntimeException("Cannot find " + confProperty);
        }
      }
      lc.getStatusManager().add(new InfoStatus("Found resource [" + url.toString() + "]", this));
      lc.reset();
      // for testing when launch log outer of tomcat
      if (catalinaBase == null) {
        System.setProperty("catalina.base", System.getProperty("java.io.tmpdir"));
      }
      configurator.doConfigure(url);
    } catch (JoranException | MalformedURLException e) {
      e.printStackTrace();
    }
  }

}
