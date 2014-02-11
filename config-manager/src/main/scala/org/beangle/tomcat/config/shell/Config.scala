package org.beangle.tomcat.config.shell

import java.io.{ File, StringWriter }
import org.beangle.commons.io.Files
import org.beangle.commons.lang.SystemInfo
import org.beangle.tomcat.config.internal.ScalaObjectWrapper
import org.beangle.tomcat.config.model.{ Context, DataSource, Farm, Webapp }
import freemarker.cache.ClassTemplateLoader
import freemarker.template.Configuration
import org.beangle.commons.lang.Numbers
import java.util.Scanner

object Config {

  def read(): Option[Configuration] = {
    None
  }

  def prompt(msg: String, f: => Boolean, p: String => Unit) {
    print(msg)
    val scanner = new Scanner(System.in)
    while (!f && scanner.hasNextLine()) {
      val content = scanner.nextLine()
      p(content)
      if (!f) print(msg)
    }
  }

  def templateFarm(): Farm = {
    var farm: Farm = null
    prompt("create tomcat farm(single or farm)?", null != farm, template => {
      if ("farm" == template) {
        var serverCount = 0
        prompt("enter server count(<10):", serverCount > 0, cnt => {
          if (Numbers.isDigits(cnt)) {
            if (Numbers.toInt(cnt) > 10) println("Cannot create more than 10 server,try again.")
            else serverCount = Numbers.toInt(cnt)
          }
        })
        farm = Farm.build(serverCount)
      } else if ("single" == template) {
        farm = Farm.single
      }
    })
    farm
  }

  def main(args: Array[String]) {
    val target = new File(SystemInfo.user.dir + "/" + "tomcat-config.xml")
    if (!target.exists()) {
      target.createNewFile()
      println("Create a new tomcat config file :" + target)
    } else {
      println("Read tomcat config file :" + target)
    }

    val farm = templateFarm()
    //    farm.ajp = new AjpConnector
    //    val server1 = new Server("server1", 8005)
    //    server1.port(8080, 8443, 8009)
    //    farm.servers += server1
    //
    //    val server2 = new Server("server2", 8006)
    //    server2.port(8081, 8444, 8010)
    //    farm.servers += server2

    val webapp = new Webapp
    val context1 = new Context("/")
    context1.runAt = farm.name
    webapp.contexts += context1

    val resource = new DataSource("jdbc/beangle")
    resource.url = "oracle"
    resource.username = "beangle"
    context1.dataSources += resource

    val data = new collection.mutable.HashMap[String, Any]()
    data.put("farms", List(farm))
    data.put("webapp", webapp)
    write(data, target)
  }

  def write(data: collection.mutable.HashMap[String, Any], target: File) {
    val sw = new StringWriter()
    val cfg = new Configuration()
    cfg.setTemplateLoader(new ClassTemplateLoader(getClass, "/"))
    cfg.setObjectWrapper(new ScalaObjectWrapper())
    cfg.setNumberFormat("0.##")
    val freemarkerTemplate = cfg.getTemplate("tomcat-config.xml.ftl")
    freemarkerTemplate.process(data, sw)
    Files.writeStringToFile(target, sw.toString)
    sw.close()
  }
}
