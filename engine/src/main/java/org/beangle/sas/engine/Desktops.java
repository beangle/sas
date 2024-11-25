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

import java.awt.*;
import java.net.URI;

public class Desktops {

  public static void openBrowser(String url) {
    GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
    if (ge.isHeadlessInstance()) {
      return;
    }
    try {
      var desktopClass = Class.forName("java.awt.Desktop");
      var supported = (boolean) desktopClass.getMethod("isDesktopSupported").invoke(null);
      var uri = new URI(url);
      if (supported) {
        var desktop = desktopClass.getMethod("getDesktop").invoke(null);
        desktopClass.getMethod("browse", URI.class).invoke(desktop, uri);
        return;
      }
      var osName = System.getProperty("os.name").toLowerCase();
      var rt = Runtime.getRuntime();
      if (osName.contains("windows")) {
        rt.exec(new String[]{"rundll32", "url.dll,FileProtocolHandler", url});
      } else if (osName.contains("mac") || osName.contains("darwin")) {
        rt.exec(new String[]{"open", url});
      } else {
        var browsers = new String[]{"xdg-open", "chromium", "google-chrome", "firefox", "konqueror", "netscape", "opera", "midori"};
        var ok = false;
        for (String b : browsers) {
          try {
            rt.exec(new String[]{b, url});
            ok = true;
            break;
          } catch (Throwable e) {
          }
        }
        if (!ok) throw new RuntimeException("Cannot open browser.");
      }
    } catch (Throwable e) {
      throw new RuntimeException("Cannot open browser.", e);
    }
  }
}
