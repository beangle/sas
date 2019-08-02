/*
 * Beangle, Agile Development Scaffold and Toolkits.
 *
 * Copyright © 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.shell

import java.io.StringWriter

import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Consoles.{prompt, shell}
import org.beangle.commons.lang.Strings.isNotEmpty
import org.beangle.commons.lang.SystemInfo
import org.beangle.template.freemarker.{Configurer => FreemarkerConfigurer}

object Firewall extends ShellEnv {

  def main(args: Array[String]) {
    workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    read()

    if (null != container) {
      info()
      shell("firewall> ", Set("exit", "quit", "q"), command => command match {
        case "info"  => info()
        case "help"  => printHelp()
        case "conf"  => println(generate())
        case "apply" => apply()
        case t       => if (isNotEmpty(t)) println(t + ": command not found...")
      })
    } else {
      logger.info("Cannot find conf/server.xml")
    }
  }

  def firewalldEnabled: Boolean = {
    val p = new ProcessBuilder("which", "firewalld").start()
    IOs.readString(p.getInputStream()).contains("/usr/sbin/firewalld")
  }

  def isRoot: Boolean = {
    val p = new ProcessBuilder("id").start()
    IOs.readString(p.getInputStream()).contains("uid=0(root)")
  }

  def info() {
    println("http ports:" + container.ports.mkString(" "))
  }

  def apply() {
    if (!firewalldEnabled) {
      println("Cannot find firewalld utilities,firewall config abort.")
      return
    }
    val ports = new collection.mutable.ListBuffer[Int]
    if (!container.ports.isEmpty) {
      val answer = prompt("apply http ports:" + container.ports.mkString(" ") + "(y/n)?")
      if ("y" == answer.toLowerCase) ports ++= container.ports
    }

    if (!ports.isEmpty) {
      val sb = new StringBuilder()
      for (port <- ports) {
        sb ++= (" --add-port=" + port + "/tcp")
      }
      val cmd = "firewall-cmd --permanent --zone=public" + sb.mkString
      if (isRoot) {
        println("executing:" + cmd)
        Runtime.getRuntime().exec(cmd)
        println("firewalld changed successfully.")
      }else{
        println("Please login using root, and execute command :"+cmd)
      }
    }
  }

  def generate(): String = {
    val cfg = FreemarkerConfigurer.newConfig
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("ports", container.ports)
    val sw = new StringWriter()
    val template = cfg.getTemplate("firewall.ftl")
    template.process(data, sw)
    sw.close()
    return sw.toString()
  }

  def printHelp() {
    println(s"""Avaliable command:
  info        print server port
  conf        generate firewall configuration
  apply       apply server port config to firewall
  help        print this help conent""")
  }
}
