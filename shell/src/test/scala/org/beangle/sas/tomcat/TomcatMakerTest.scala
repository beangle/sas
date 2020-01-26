/*
 * Beangle, Agile Development Scaffold and Toolkits.
 *
 * Copyright © 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.tomcat

import java.io.File

import org.beangle.sas.model.Engine
import org.beangle.sas.util.Gen
import org.junit.runner.RunWith
import org.scalatest.matchers.should.Matchers
import org.scalatest.funspec.AnyFunSpec
import org.scalatestplus.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class TomcatMakerTest extends AnyFunSpec with Matchers {
  describe("Resolver") {
    it("make catalina engine") {
      val sasHome = "/tmp/sas"
      val engine = new Engine("tomcat85", "tomcat", "8.5.15")
      engine.jspSupport = true
      val file = new File("/tmp/apache-tomcat-8.5.15.zip")
      if (file.exists()) {
        TomcatMaker.doMakeEngine("/tmp/sas", file, engine)
        TomcatMaker.doMakeBase(sasHome, engine, "farm.server1")

        Gen.spawn(engine, "/tmp/sas/engines/tomcat-8.5.15")
      }
    }
  }
}
