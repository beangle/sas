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

package org.beangle.sas.maker

import org.beangle.sas.config.*
import org.scalatest.funspec.AnyFunSpec
import org.scalatest.matchers.should.Matchers

import java.io.File
import java.nio.file.{Files, Path}

class TomcatMakerTest extends AnyFunSpec with Matchers {
  describe("Resolver") {
    it("make catalina engine") {
      val sasHome = "/tmp/sas"
      val engine = new Engine("tomcat85", "tomcat", "8.5.15")
      val farm = new Farm("farm", engine)
      val server = new Server(farm, "server1")
      val container = new Container
      container.farms += farm
      engine.jspSupport = true
      val file = new File("/tmp/apache-tomcat-8.5.15.zip")
      if (file.exists()) {
        TomcatMaker.doMakeEngine("/tmp/sas", engine, file)
        TomcatMaker.doMakeBase(sasHome, container, server)
      }
    }

    it("render useVirtualThreads in server.xml") {
      val engine = new Engine("tomcat11", "tomcat", "11.0.25")
      val farm = new Farm("farm", engine)
      val server = new Server(farm, "server")
      server.http = 8080
      server.maxHeapSize = "300M"
      val container = new Container
      container.farms += farm
      val target = "/tmp/sas-test"
      TomcatMaker.genBaseConfig(container, server, target)
      val xml = Files.readString(Path.of(target + "/servers/farm.server/conf/server.xml"))
      xml should include("""useVirtualThreads="true"""")
      xml should not include ("maxThreads")
    }

    it("omit useVirtualThreads for tomcat 10 in server.xml") {
      val engine = new Engine("tomcat10", "tomcat", "10.1.42")
      val farm = new Farm("farm", engine)
      val server = new Server(farm, "server")
      server.http = 8080
      server.maxHeapSize = "300M"
      val container = new Container
      container.farms += farm
      val target = "/tmp/sas-test"
      TomcatMaker.genBaseConfig(container, server, target)
      val xml = Files.readString(Path.of(target + "/servers/farm.server/conf/server.xml"))
      xml should not include ("useVirtualThreads")
      xml should include("""<Connector port="8080"""")
    }
  }
}
