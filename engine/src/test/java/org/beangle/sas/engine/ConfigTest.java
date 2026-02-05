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

public class ConfigTest {
  public static void main(String[] args) {
    assertEquals("", Server.Config.normalizePath(null));
    assertEquals("", Server.Config.normalizePath("/"));
    assertEquals("/api", Server.Config.normalizePath("api"));
    assertEquals("/api", Server.Config.normalizePath("api/"));
    assertEquals("/api", Server.Config.normalizePath("//api"));
  }

  private static void assertEquals(String expected, String result) {
    if (!expected.equals(result)) {
      throw new IllegalArgumentException("not equals:[" + expected + "] , result is [" + result + "]");
    }
  }
}
