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

import java.lang.management.ManagementFactory;

public class EnvProfile {

  public static boolean isDebugMode() {
    var args = ManagementFactory.getRuntimeMXBean().getInputArguments();
    return args.toString().indexOf("-agentlib:jdwp") > 0;
  }

  public static boolean isDevMode() {
    String cdiProfiles = System.getProperty("beangle.cdi.profiles");
    if (null != cdiProfiles && cdiProfiles.contains("dev")) {
      return true;
    }
    return isDebugMode();
  }

}
