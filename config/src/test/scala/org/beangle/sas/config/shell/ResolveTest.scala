/*
 * Beangle, Agile Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2017, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.config.shell

import org.junit.runner.RunWith
import org.scalatest.{ FunSpec, Matchers }
import org.scalatest.junit.JUnitRunner
import java.io.File
import org.beangle.sas.config.model.Engine

@RunWith(classOf[JUnitRunner])
class ResolveTest extends FunSpec with Matchers {
  describe("Resolver") {
    it("make catalina engine") {
      val sasHome = "/tmp/sas"
      val engine = new Engine("tomcat85", "tomcat", "8.5.15")
      val file = new File("/tmp/apache-tomcat-8.5.15.zip")
      if (file.exists()) {
        Resolve.makeTomcatEngine("/tmp/sas", file)
        Resolve.makeTomcatBase(sasHome, engine, "farm.server1")
      }
    }
  }
}
