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
package org.beangle.tomcat.configurer.shell

import java.io.File

import scala.Range

import org.beangle.commons.io.Files
import org.beangle.commons.lang.{ Strings, SystemInfo }
import org.beangle.commons.lang.Consoles.{ confirm, prompt, shell }
import org.beangle.commons.lang.Numbers.{ isDigits, toInt }
import org.beangle.data.jdbc.vendor.{ UrlFormat, Vendors }
import org.beangle.tomcat.configurer.model.{ Container, Deployment, Farm, Resource, Webapp }
import org.beangle.tomcat.configurer.util.Template

object Config extends ShellEnv {

  var currentFarm: Option[Farm] = None
  var currentWebapp: Option[Webapp] = None

  def printHelp() {
    println("""  info              print config xml content
  save              save tomcat config 
  apply             apply the tomcat config to tomcat server
  create farm       create a tomcat farm profile
  remove farm       remove a tomcat farm profile
  create webapp     create a webapp context
  remove webapp     remove a webapp context
  create datasource create a datasource config
  remove datasource remove a datasource config
  add ref           add a resource reference
  remove ref        remove a resource reference
  deploy            create a deployment
  undeploy          remove a deployment
  jvmopts           set jvm options
  help              print this help conent""")
  }

  def main(args: Array[String]) {
    workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    read()
    if (null == container) {
      createConfig(new File(workdir + "/config.xml"))
    } else {
      println("command:help info save apply exit(quit/q)")

      shell({
        val prefix =
          if (currentWebapp.isDefined) currentWebapp.get.name
          else if (currentFarm.isDefined) currentFarm.get.name
          else "tomcat"
        prefix + " >"
      }, Set("exit", "quit", "q"), command => command match {
        case "info" => println(toXml)
        case "create farm" => createFarm()
        case "remove farm" => removeFarm()
        case "use farm" => useFarm()
        case "create webapp" => createWebapp()
        case "remove webapp" => removeWebapp()
        case "create datasource" => createDataSource()
        case "remove datasource" => removeResource()
        case "add ref" => addResourceRef()
        case "remove ref" => removeResourceRef()
        case "deploy" => createDeployment()
        case "undeploy" => removeDeployment()
        case "jvmopts" => setJvmOpts()
        case "save" =>
          println("Writing to " + workdir + "/config.xml")
          Files.writeString(new File(workdir + "/config.xml"), toXml)
        case "apply" => applyConfig()
        case "help" => printHelp()
        case t => if (Strings.isNotEmpty(t)) println(t + ": command not found...")
      })
    }
  }

  def createFarm(): Farm = {
    val farmName = prompt("farm name?", "tomcat8", name => !container.farmNames.contains(name))
    val farm = prompt("create tomcat farm(single or cluster)?", "single", c => c == "cluster" || c == "single") match {
      case "cluster" => Farm.build(farmName, toInt(prompt("enter server count(<10):", "3", cnt => isDigits(cnt) && toInt(cnt) <= 10)))
      case "single" => Farm.build(farmName, 1)
    }
    container.farms += farm
    farm
  }

  def removeFarm() {
    if (container.farmNames.isEmpty) {
      println("farms is empty!")
    } else {
      val farmName = prompt("remove farm name?", null, name => container.farmNames.contains(name))
      container.farms.find(f => f.name == farmName).foreach { f => container.farms -= f }
      container.deployments --= container.deployments.find { d => d.on == farmName }
    }
  }

  def createWebapp(): Webapp = {
    val name = prompt("webapp name:", null, p => !container.webappNames.contains(p))
    val docBase = prompt("webapp docbase:", null, p => p.length() > 0)
    val webapp = new Webapp(name)
    webapp.docBase = docBase
    container.webapps += webapp

    val runAt =
      if (container.farmNames.size == 1) container.farmNames.head
      else if (container.farmNames.size > 1) prompt("choose farm " + container.farmNames + ":", container.farmNames.head, name => container.farmNames.contains(name))
      else null

    if (null != runAt) {
      val context = prompt("webapp context path:", "/", p => p.length() > 0)
      container.deployments += new Deployment(webapp.name, runAt, processContext(context))
    }
    webapp
  }

  def removeWebapp() {
    if (container.webapps.isEmpty) {
      println("webapps is empty!")
    } else {
      val name = prompt("remove webapp " + container.webappNames + ":", null, p => container.webappNames.contains(p))
      container.webapps.find(c => c.name == name).foreach { c =>
        if (confirm("remove webapp [" + name + "](Y/n)?")) container.webapps -= c
      }
    }
  }

  def removeResource() {
    if (container.resources.isEmpty) {
      println("resources is empty!")
    } else {
      val name = prompt("choose resource " + container.resourceNames + ":", null, p => container.resourceNames.contains(p))
      container.resources.values.find(r => r.name == name).foreach { r =>
        if (confirm("remove  resource [" + r.name + "](Y/n)?")) {
          container.resources.remove(r.name)
          for (webapp <- container.webapps) {
            webapp.resources -= r
          }
        }
      }
    }
  }

  def addResourceRef() {
    if (container.resources.isEmpty || container.webappNames.isEmpty) {
      println("resources or webapps is empty!")
    } else {
      val webappNames = container.webappNames
      val name = prompt("choose webapp" + webappNames + ":", webappNames.head, p => webappNames.contains(p))
      container.webapps.find(c => c.name == name) foreach { webapp =>
        val candinates = container.resourceNames -- webapp.resourceNames
        val resourceName = prompt("choose resource " + candinates + ":", candinates.head, p => candinates.contains(p))
        webapp.resources += container.resources(resourceName)
      }
    }
  }

  def removeResourceRef() {
    if (container.resources.isEmpty || container.webappNames.isEmpty) {
      println("resources or webapps is empty!")
    } else {
      val name = prompt("choose webapp" + container.webappNames + ":", container.webappNames.head, p => container.webappNames.contains(p))
      container.webapps.find(c => c.name == name) foreach { webapp =>
        val resourceName = prompt("choose resource " + webapp.resourceNames + ":", webapp.resourceNames.head, p => webapp.resourceNames.contains(p))
        webapp.resources.find(r => r.name == resourceName).foreach { r =>
          if (confirm("remove resource reference [" + resourceName + "](Y/n)?")) webapp.resources -= r
        }
      }
    }
  }

  def createDeployment() {
    if (container.webapps.isEmpty || container.farms.isEmpty) {
      println("farms or webapps is empty!")
    } else {
      val webappNames = container.webappNames
      val name = prompt("choose webapp" + webappNames + ":", webappNames.head, p => webappNames.contains(p))
      container.webapps.find(c => c.name == name) foreach { webapp =>
        val candinates = container.farmNames ++ container.serverNames
        val farmName = prompt("choose farm " + candinates + ":", candinates.head, p => candinates.contains(p))
        container.deployments.find { d => d.webapp == name } match {
          case Some(deploy) =>
            var context = prompt("webapp context path:", deploy.path, p => p.length() > 0)
            deploy.path = processContext(context)
            deploy.on = farmName
          case None =>
            var context: String = prompt("webapp context path:", "/", p => p.length() > 0)
            container.deployments += new Deployment(name, farmName, processContext(context))
        }
      }
    }
  }

  def removeDeployment() {
    if (container.webapps.isEmpty || container.farms.isEmpty) {
      println("farms or webapps is empty!")
    } else {
      val webappNames = container.webappNames
      val name = prompt("choose webapp" + webappNames + ":", webappNames.head, p => webappNames.contains(p))
      container.deployments.find { d => d.webapp == name } foreach { d =>
        container.deployments -= d
      }
    }
  }

  def createDataSource(): Resource = {
    println("create datasource :")
    var name: String = null
    val ds = new Resource(prompt("name(jdbc/yourname):", null, name => !container.resourceNames.contains(name)))
    ds.username = prompt("username:")

    val drivers = Vendors.drivers
    val driver = prompt("choose driver " + Vendors.driverPrefixes + ":", "postgresql", d => drivers.contains(d))
    val driverInfo = drivers(driver)
    ds.driverClassName = driverInfo.className
    val urlformats = new collection.mutable.HashMap[Int, String]
    val formatPrompts = new StringBuilder()
    Range(0, driverInfo.urlformats.length).foreach { i =>
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
    container.resources.put(ds.name, ds)
    ds
  }

  def createConfig(target: File) {
    println("Create a new tomcat config file :" + target)
    target.createNewFile()
    container = new Container
    val farm = createFarm()
    val webapp = createWebapp()
    createDataSource()
    Files.writeString(target, toXml)
  }

  def setJvmOpts() {
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

  def useFarm() {
    if (container.farmNames.isEmpty) {
      println("farm is empty,create first.")
    } else {
      val farmName = prompt("choose farm name?", null, name => container.farmNames.contains(name))
      container.farms.find(f => f.name == farmName).foreach { f => currentFarm = Some(f)
      }
    }
  }

  def applyConfig() {
    for (farm <- container.farms) {
      Template.generate(container, farm, workdir)
    }
    println("Apply configuration success,check it in " + workdir)
  }

  private def processContext(context: String): String = {
    var path = context
    if (!path.startsWith("/")) path = "/" + path
    if (path.length > 1 && path.endsWith("/")) path = path.substring(0, path.length - 1)
    path
  }
}
