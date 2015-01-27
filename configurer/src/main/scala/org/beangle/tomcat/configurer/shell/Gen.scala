package org.beangle.tomcat.configurer.shell

import java.io.{ File, FileInputStream }

import org.beangle.tomcat.configurer.model.Container
import org.beangle.tomcat.configurer.util.Template

object Gen {

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      println("Usage: Gen /path/to/config.xml farm or server -DCATALINA_BASE=/path/to/catalina_base")
      return
    }
    val configFile = args(0)
    val container = Container(scala.xml.XML.load(new FileInputStream(new File(configFile))))
    val target = args(1)
    var targetDir = System.getProperty("CATALINA_BASE")
    if (null == targetDir) {
      targetDir = System.getenv("CATALINA_BASE")
    }
    if (targetDir == null) {
      targetDir = new File(configFile).getParent
    }
    println(targetDir)
    container.farms foreach { farm =>
      if (farm.name == target) {
        Template.generate(container, farm, targetDir)
      } else {
        farm.servers foreach { server =>
          if (target == (farm.name + "." + server.name)) {
            Template.generate(container, farm, server, targetDir)
          }
        }
      }
    }
  }
}