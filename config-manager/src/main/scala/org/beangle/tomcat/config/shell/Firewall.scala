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

import java.io.{ File, StringWriter }
import org.beangle.commons.io.Files.{ /, readString, writeString }
import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Consoles.{ prompt, shell }
import org.beangle.commons.lang.Strings.{ isNotEmpty, replace }
import org.beangle.commons.lang.SystemInfo
import org.beangle.tomcat.config.util.ScalaObjectWrapper
import freemarker.cache.ClassTemplateLoader
import freemarker.template.Configuration
import org.beangle.commons.lang.ClassLoaders
import org.beangle.commons.io.Files

object Firewall extends ShellEnv {
  val firewalldEnabled: Boolean = isFirewallDeamonEnabled
  val isRoot = isRootUser

  def main(args: Array[String]) {
    workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    read()

    if (null != container) {
      info()
      shell("firewall> ", Set("exit", "quit", "q"), command => command match {
        case "info" => info()
        case "help" => printHelp()
        case "conf" => println(generate())
        case "apply" => apply()
        case t => if (isNotEmpty(t)) println(t + ": command not found...")
      })
    } else {
      logger.info("Cannot find config.xml")
    }
  }

  def isFirewallDeamonEnabled(): Boolean = {
    val p = new ProcessBuilder("which", "firewalld").start()
    IOs.readString(p.getInputStream()).contains("/usr/sbin/firewalld")
  }

  def isRootUser(): Boolean = {
    val p = new ProcessBuilder("id").start()
    IOs.readString(p.getInputStream()).contains("uid=0(root)")
  }

  def info() {
    println("http ports:" + container.httpPorts.mkString(" "))
    println("https ports:" + container.httpsPorts.mkString(" "))
    println("ajp ports:" + container.ajpPorts.mkString(" "))
  }

  def apply() {
    if (!firewalldEnabled && !isRoot) {
      println("Please run the program by root")
      return
    }
    val ports = new collection.mutable.ListBuffer[Int]
    if (!container.httpPorts.isEmpty) {
      val answer = prompt("apply http ports:" + container.httpPorts.mkString(" ") + "(y/n)?")
      if ("y" == answer.toLowerCase) ports ++= container.httpPorts
    }
    if (!container.httpsPorts.isEmpty) {
      val answer = prompt("apply https ports:" + container.httpsPorts.mkString(" ") + "(y/n)?")
      if ("y" == answer.toLowerCase) ports ++= container.httpsPorts
    }
    if (!container.ajpPorts.isEmpty) {
      val answer = prompt("apply ajp ports:" + container.ajpPorts.mkString(" ") + "(y/n)?")
      if ("y" == answer.toLowerCase) ports ++= container.ajpPorts
    }

    if (!ports.isEmpty) {
      if (firewalldEnabled) {
        val sb = new StringBuilder()
        for (port <- ports)
          sb ++= (" --add-port=" + port + "/tcp")
        Runtime.getRuntime().exec("firewall-cmd --permanent --zone=public" + sb.mkString)
        println("firewalld changed successfully.")
      } else {
        for (port <- ports)
          Runtime.getRuntime().exec("iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport " + port + " -j ACCEPT")
        Runtime.getRuntime().exec("service iptables save")
        println("change /etc/sysconfig/iptables success.")
      }
    }
  }

  def generate(): String = {
    val cfg = new Configuration()
    cfg.setTemplateLoader(new ClassTemplateLoader(getClass, "/"))
    cfg.setObjectWrapper(new ScalaObjectWrapper())
    cfg.setNumberFormat("0.##")
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("ports", container.ports)
    val sw = new StringWriter()
    val template = cfg.getTemplate(if (firewalldEnabled) "firewall.ftl" else "iptables_rule.ftl")
    template.process(data, sw)
    sw.close()
    return sw.toString()
  }

  def printHelp() {
    val name = if (firewalldEnabled) "firewall" else "iptables"
    println(s"""Avaliable command:
  info        print server port
  conf        generate $name configuration
  apply       apply server port config to $name
  help        print this help conent""")
  }
}