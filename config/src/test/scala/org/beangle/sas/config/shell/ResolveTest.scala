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
