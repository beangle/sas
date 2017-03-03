package org.beangle.as.config.shell

import java.io.{ File, FileInputStream }

import org.beangle.as.config.model.Container
import org.beangle.as.config.util.Template

object Gen {

  def main(args: Array[String]): Unit = {
    if (args.length < 3) {
      println("Usage: Gen /path/to/server.xml target targetDir")
      return
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    val target = args(1)
    val targetDir = args(2)
    val beangleASHome = configFile.getParentFile.getParentFile.getCanonicalPath

    Resolve.resolve(container, beangleASHome)

    container.farms foreach { farm =>
      if (farm.name == target || target == "all") {
        Template.generate(container, farm, targetDir)
      } else {
        farm.servers foreach { server =>
          if (target == server.qualifiedName) Template.generate(container, farm, server, targetDir)
        }
      }
    }
  }

}
