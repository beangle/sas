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

import org.beangle.sas.engine.Dependency;

public class DependencyTest {
  public static void main(String[] args) {
    var gavs = "org.beangle.commons:beangle-commons-core:5.5.0\norg.beangle.data:beangle-model:3.0.0;";
    var first = Dependency.Resolver.resolve(gavs);

    var gavs2 = "org.beangle.commons:beangle-commons-core:5.6.0\norg.beangle.data:beangle-orm:3.0.0;";
    var second = Dependency.Resolver.resolve(gavs2);

    var result = Dependency.Resolver.merge(first,second);
    System.out.println(result);

  }
}
