package org.beangle.tomcat.config

import java.io.{ File, StringWriter }
import org.beangle.commons.io.Files
import org.beangle.commons.lang.SystemInfo
import org.beangle.tomcat.config.internal.ScalaObjectWrapper
import org.beangle.tomcat.config.model.{ Farm, Server, AjpConnector }
import freemarker.cache.ClassTemplateLoader
import freemarker.template.Configuration
import org.beangle.tomcat.config.model.Webapp
import org.beangle.tomcat.config.model.Context
import org.beangle.tomcat.config.model.DataSource

object Shell {
  def main(args: Array[String]) {
    val target = new File(SystemInfo.user.dir + "/" + "tomcat-config.xml")
    if (!target.exists()) {
      target.createNewFile()
      println("Create a new tomcat config file :" + target)
    } else {
      println("Read tomcat config file :" + target)
    }
    val farm = new Farm
    farm.ajp = new AjpConnector
    val server1 = new Server("server1", 8005)
    server1.port(8080, 8443, 8009)
    farm.servers += server1

    val server2 = new Server("server2", 8006)
    server2.port(8081, 8444, 8010)
    farm.servers += server2

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
class ServerConfig {

}