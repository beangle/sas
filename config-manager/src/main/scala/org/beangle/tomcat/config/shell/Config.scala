package org.beangle.tomcat.config.shell

import java.io.{ File, StringWriter }
import org.beangle.commons.io.Files
import org.beangle.commons.lang.Consoles.{ prompt, shell, confirm }
import org.beangle.commons.lang.Numbers.{ isDigits, toInt }
import org.beangle.commons.lang.Range.{ range }
import org.beangle.commons.lang.SystemInfo
import org.beangle.tomcat.config.internal.ScalaObjectWrapper
import org.beangle.tomcat.config.model.{ Context, DataSource, Farm, TomcatConfig, Webapp }
import freemarker.cache.ClassTemplateLoader
import freemarker.template.Configuration
import org.beangle.commons.lang.Strings
import org.beangle.data.jdbc.vendor.{ Vendors, DriverInfo, UrlFormat }

object Config {

  def read(): Option[Configuration] = {
    None
  }

  def createFarm(conf: TomcatConfig): Farm = {
    val farmName = prompt("farm name?", "tomcat7", name => !conf.farmNames.contains(name))
    val farm = prompt("create tomcat farm(single or cluster)?", "cluster", c => c == "cluster" || c == "single") match {
      case "cluster" => Farm.build(farmName, toInt(prompt("enter server count(<10):", "3", cnt => isDigits(cnt) && toInt(cnt) <= 10)))
      case "single" => Farm.build(farmName, 1)
    }
    conf.farms += farm
    farm
  }

  def removeFarm(conf: TomcatConfig) {
    if (conf.farmNames.isEmpty) {
      println("farms is empty!")
    } else {
      val farmName = prompt("remove farm name?", null, name => conf.farmNames.contains(name))
      conf.farms.find(f => f.name == farmName).foreach { f => conf.farms -= f }
    }
  }

  def createContext(conf: TomcatConfig): Context = {
    if (conf.farmNames.isEmpty) {
      println("create farm first!")
      null
    } else {
      var path: String = prompt("context path:", "/", p => !conf.webapp.contextPaths.contains(p))
      if (!path.startsWith("/")) path = "/" + path
      if (path.length > 1 && path.endsWith("/")) path = path.substring(0, path.length - 1)
      val context = new Context(path)
      conf.webapp.contexts += context
      if (conf.farmNames.size == 1) context.runAt = conf.farmNames.head
      else context.runAt = prompt("choose farm " + conf.farmNames + ":", conf.farmNames.head, name => conf.farmNames.contains(name))
      context
    }
  }

  def removeContext(conf: TomcatConfig) {
    if (conf.webapp.contextPaths.isEmpty) {
      println("context is empty!")
    } else {
      val path = prompt("remove context path " + conf.webapp.contextPaths + ":", null, p => conf.webapp.contextPaths.contains(p))
      conf.webapp.contexts.find(c => c.path == path).foreach { c =>
        if (confirm("remove context path [" + path + "](Y/n)?")) conf.webapp.contexts -= c
      }
    }
  }

  def removeDataSource(conf: TomcatConfig) {
    if (conf.webapp.contexts.isEmpty) {
      println("context is empty!")
    } else {
      var context: Context = null
      if (conf.webapp.contexts.size == 1) context = conf.webapp.contexts.head
      else {
        val path = prompt("choose context " + conf.webapp.contextPaths + ":", null, p => conf.webapp.contextPaths.contains(p))
        context = conf.webapp.contexts.find(c => c.path == path).get
      }
      val name = prompt("choose datasource " + context.dataSourceNames + ":", null, p => context.dataSourceNames.contains(p))
      context.dataSources.find(c => c.name == name).foreach { d =>
        if (confirm("remove context path [" + d.name + "](Y/n)?")) context.dataSources -= d
      }

    }
  }
  def createDataSource(conf: TomcatConfig): DataSource = {
    if (conf.webapp.contexts.isEmpty) {
      println("create context first!")
      null
    } else {
      var context: Context = null
      if (conf.webapp.contexts.size == 1) context = conf.webapp.contexts.head
      else {
        val path = prompt("choose context " + conf.webapp.contextPaths + ":", null, p => conf.webapp.contextPaths.contains(p))
        context = conf.webapp.contexts.find(c => c.path == path).get
      }
      println("create datasource for " + context.path + ":")
      var name: String = null
      val ds = new DataSource(prompt("name(jdbc/yourname):", null, name => !context.dataSourceNames.contains(name)))
      ds.username = prompt("username:")

      val drivers = Vendors.drivers
      ds.driver = prompt("choose driver " + Vendors.driverPrefixes + ":", "oracle", d => drivers.contains(d))
      val driverInfo = drivers(ds.driver)
      val urlformats = new collection.mutable.HashMap[Int, String]
      val formatPrompts = new StringBuilder()
      range(0, driverInfo.urlformats.length).foreach { i =>
        urlformats += (i -> driverInfo.urlformats(i))
        formatPrompts ++= (i + " ->" + driverInfo.urlformats(i) + "\n")
      }
      var index = 0
      if (urlformats.size > 1) {
        println("So many url formats:\n" + formatPrompts)
        index = toInt(prompt("choose formats index:", "0", i => urlformats.contains(toInt(i))))
      }

      val format = new UrlFormat(urlformats(index))
      val params = format.params
      val values = new collection.mutable.HashMap[String, String]
      params.foreach { param => values.put(param, prompt("enter " + param + ":")) }
      ds.url = "jdbc:" + driverInfo.prefix + ":" + format.fill(values.toMap)
      context.dataSources += ds
      ds
    }
  }

  def createConfig(target: File) {
    println("Create a new tomcat config file :" + target)
    val conf = new TomcatConfig
    val farm = createFarm(conf)
    val context = createContext(conf)
    createDataSource(conf)
    Files.writeStringToFile(target, toString(conf))
  }

  def main(args: Array[String]) {
    val target = new File(SystemInfo.user.dir + "/" + "tomcat-config.xml")
    if (!target.exists()) {
      target.createNewFile()
      createConfig(target)
    } else {
      println("Read tomcat config file :" + target)
      //fixme
      val conf = new TomcatConfig
      println("print command:help,info,create farm,create context,create resource or exit")
      shell("tomcat > ", Set("exit", "quit", "q"), command => command match {
        case "info" => println(toString(conf))
        case "create farm" => createFarm(conf)
        case "remove farm" => removeFarm(conf)
        case "create context" => createContext(conf)
        case "remove context" => removeContext(conf)
        case "create datasource" => createDataSource(conf)
        case "remove datasource" => removeDataSource(conf)
        case t => if (Strings.isNotEmpty(t)) println(t + ": command not found...")
      })
      Files.writeStringToFile(target, toString(conf))
    }
  }

  def toString(conf: TomcatConfig): String = {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("config", conf)
    val sw = new StringWriter()
    val cfg = new Configuration()
    cfg.setTemplateLoader(new ClassTemplateLoader(getClass, "/"))
    cfg.setObjectWrapper(new ScalaObjectWrapper())
    cfg.setNumberFormat("0.##")
    val freemarkerTemplate = cfg.getTemplate("tomcat-config.xml.ftl")
    freemarkerTemplate.process(data, sw)
    sw.close()
    sw.toString()
  }

}
