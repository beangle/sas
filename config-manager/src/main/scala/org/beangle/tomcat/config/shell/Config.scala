/*
 * Beangle, Agile Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2014, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.tomcat.config.shell

import java.io.{ File, FileInputStream }
import org.beangle.commons.io.Files
import org.beangle.commons.lang.{ Strings, SystemInfo }
import org.beangle.commons.lang.Consoles.{ confirm, prompt, shell }
import org.beangle.commons.lang.Consoles
import org.beangle.commons.lang.Numbers.{ isDigits, toInt }
import org.beangle.commons.lang.Range.range
import org.beangle.data.jdbc.vendor.{ UrlFormat, Vendors }
import org.beangle.tomcat.config.model.{ Context, DataSource, Farm, Container }
import org.beangle.tomcat.config.util.Serializer.toXml
import org.beangle.tomcat.config.util.Template
import org.beangle.tomcat.jdbc.Encryptor
import org.beangle.commons.io.IOs
import org.beangle.commons.lang.ClassLoaders
import org.beangle.tomcat.config.util.DataSourceConfig

class Config

object Config {

  var currentFarm: Option[Farm] = None
  var currentContext: Option[Context] = None

  def read(target: File): Option[Container] = {
    if (target.exists()) {
      Some(Container(scala.xml.XML.load(new FileInputStream(target))))
    } else
      None
  }

  def createFarm(container: Container): Farm = {
    val farmName = prompt("farm name?", "tomcat7", name => !container.farmNames.contains(name))
    val farm = prompt("create tomcat farm(single or cluster)?", "single", c => c == "cluster" || c == "single") match {
      case "cluster" => Farm.build(farmName, toInt(prompt("enter server count(<10):", "3", cnt => isDigits(cnt) && toInt(cnt) <= 10)))
      case "single" => Farm.build(farmName, 1)
    }
    container.farms += farm
    farm
  }

  def removeFarm(container: Container) {
    if (container.farmNames.isEmpty) {
      println("farms is empty!")
    } else {
      val farmName = prompt("remove farm name?", null, name => container.farmNames.contains(name))
      container.farms.find(f => f.name == farmName).foreach { f => container.farms -= f }
    }
  }

  def createContext(container: Container): Context = {
    if (container.farmNames.isEmpty) {
      println("create farm first!")
      null
    } else {
      var path: String = prompt("context path:", "/", p => !container.webapp.contextPaths.contains(p))
      if (!path.startsWith("/")) path = "/" + path
      if (path.length > 1 && path.endsWith("/")) path = path.substring(0, path.length - 1)
      val context = new Context(path)
      container.webapp.contexts += context
      if (container.farmNames.size == 1) context.runAt = container.farmNames.head
      else context.runAt = prompt("choose farm " + container.farmNames + ":", container.farmNames.head, name => container.farmNames.contains(name))
      context
    }
  }

  def removeContext(container: Container) {
    if (container.webapp.contextPaths.isEmpty) {
      println("context is empty!")
    } else {
      val path = prompt("remove context path " + container.webapp.contextPaths + ":", null, p => container.webapp.contextPaths.contains(p))
      container.webapp.contexts.find(c => c.path == path).foreach { c =>
        if (confirm("remove context path [" + path + "](Y/n)?")) container.webapp.contexts -= c
      }
    }
  }

  def removeDataSource(container: Container) {
    if (container.webapp.contexts.isEmpty) {
      println("context is empty!")
    } else {
      var context: Context = null
      if (container.webapp.contexts.size == 1) context = container.webapp.contexts.head
      else {
        val path = prompt("choose context " + container.webapp.contextPaths + ":", null, p => container.webapp.contextPaths.contains(p))
        context = container.webapp.contexts.find(c => c.path == path).get
      }
      val name = prompt("choose datasource " + context.dataSourceNames + ":", null, p => context.dataSourceNames.contains(p))
      context.dataSources.find(c => c.name == name).foreach { d =>
        if (confirm("remove context path [" + d.name + "](Y/n)?")) context.dataSources -= d
      }
    }
  }

  def createDataSource(container: Container): DataSource = {
    if (container.webapp.contexts.isEmpty) {
      println("create context first!")
      null
    } else {
      var context: Context = null
      if (container.webapp.contexts.size == 1) context = container.webapp.contexts.head
      else {
        val path = prompt("choose context " + container.webapp.contextPaths + ":", null, p => container.webapp.contextPaths.contains(p))
        context = container.webapp.contexts.find(c => c.path == path).get
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
    target.createNewFile()
    val conf = new Container
    val farm = createFarm(conf)
    val context = createContext(conf)
    createDataSource(conf)
    Files.writeString(target, toXml(conf))
  }

  def setJvmOpts(container: Container) {
    if (container.farmNames.isEmpty) {
      println("farm is empty,create first.")
    } else {
      currentFarm match {
        case Some(farm) => farm.jvmopts = prompt("jvm opts:")
        case None => {
          val farmName = prompt("choose farm name?", null, name => container.farmNames.contains(name))
          container.farms.find(f => f.name == farmName).foreach { f =>
            f.jvmopts = prompt("jvm opts:")
          }
        }
      }
    }
  }

  def useFarm(container: Container) {
    if (container.farmNames.isEmpty) {
      println("farm is empty,create first.")
    } else {
      val farmName = prompt("choose farm name?", null, name => container.farmNames.contains(name))
      container.farms.find(f => f.name == farmName).foreach { f => currentFarm = Some(f)
      }
    }
  }

  def applyConfig(container: Container, workdir: String) {
    for (farm <- container.farms; server <- farm.servers) {
      Template.generate(container, farm, server, workdir)
      Template.generateEnv(container, farm, workdir)
      copyResources(Array("/bin/startServer.sh", "/bin/stopServer.sh", "/conf/logging.properties"), workdir + "/" + farm.name)
    }
    for (context <- container.webapp.contexts) {
      container.farms.find(f => f.name == context.runAt).foreach { farm =>
        for (ds <- context.dataSources) {
          DataSourceConfig.config(ds)
          if (null == ds.password) ds.password = new Encryptor(null).encrypt(Consoles.readPassword("enter datasource [%1$s] %2$s password:", ds.name, ds.username))
        }
        Template.generate(container, farm, context, workdir)
      }
    }
    println("Apply configuration success,check it in " + workdir)
  }

  private def copyResources(paths: Array[String], target: String) {
    for (path <- paths) {
      val file = new File(target + path)
      IOs.copy(ClassLoaders.getResourceAsStream("tomcat" + path, getClass), Files.writeOpen(file))
      if (file.getName().endsWith(".sh")) file.setExecutable(true)
    }
  }

  def setAppBase(container: Container) {
    container.webapp.base = prompt("set app base:", "webapps")
  }

  def printHelp() {
    println("""  info              print config xml content"
  save              save tomcat config 
  apply             apply the tomcat config to tomcat server
  create farm       create a tomcat farm profile
  remove farm       remove a tomcat farm profile
  create context    create a webapp context
  remove context    remove a webapp context
  create datasource create a datasource config
  remove datasource remove a datasource config
  jvmopts           set jvm options
  appbase           set app base directory
  help              print this help conent""")
  }

  def main(args: Array[String]) {
    val workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    val target = new File(workdir + "/config.xml")

    val confOpt = read(target)
    if (confOpt.isEmpty) {
      createConfig(target)
    } else {
      println("Read tomcat config file :" + target)
      val conf = confOpt.get
      println("command:help info save apply exit(quit/q)")

      shell({
        val prefix =
          if (currentContext.isDefined) currentContext.get.path
          else if (currentFarm.isDefined) currentFarm.get.name
          else "tomcat"
        prefix + " >"
      }, Set("exit", "quit", "q"), command => command match {
        case "info" => println(toXml(conf))
        case "create farm" => createFarm(conf)
        case "remove farm" => removeFarm(conf)
        case "use farm" => useFarm(conf)
        case "create context" => createContext(conf)
        case "remove context" => removeContext(conf)
        case "create datasource" => createDataSource(conf)
        case "remove datasource" => removeDataSource(conf)
        case "jvmopts" => setJvmOpts(conf)
        case "appbase" => setAppBase(conf)
        case "save" => Files.writeString(target, toXml(conf))
        case "apply" => applyConfig(conf, workdir)
        case "help" => printHelp()
        case t => if (Strings.isNotEmpty(t)) println(t + ": command not found...")
      })

    }
  }

}
