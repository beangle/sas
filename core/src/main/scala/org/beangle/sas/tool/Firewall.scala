/*
 * Copyright (C) 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.beangle.sas.tool

import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Consoles.{prompt, shell}
import org.beangle.commons.lang.Strings.isNotEmpty
import org.beangle.commons.lang.SystemInfo
import org.beangle.template.freemarker.Configurator

import java.io.StringWriter

object Firewall extends ShellEnv {

  def main(args: Array[String]): Unit = {
    workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    read() foreach { container =>
      info()
      shell("firewall> ", Set("exit", "quit", "q"), {
        case "?" => printHelp()
        case "info" => info()
        case "help" => printHelp()
        case "conf" => println(generate())
        case "apply" => apply()
        case t => if (isNotEmpty(t)) println(t + ": command not found...")
      })
    }
  }

  def firewalldEnabled: Boolean = {
    val p = new ProcessBuilder("which", "firewall-cmd").start()
    IOs.readString(p.getInputStream).contains("/usr/bin/firewall-cmd")
  }

  def isRoot: Boolean = {
    val p = new ProcessBuilder("id").start()
    IOs.readString(p.getInputStream).contains("uid=0(root)")
  }

  def info(): Unit = {
    println("http ports:" + container.ports.mkString(" "))
  }

  def apply(): Unit = {
    if (!firewalldEnabled) {
      println("Cannot find firewalld utilities,firewall config abort.")
      return
    }
    val ports = new collection.mutable.ListBuffer[Int]
    if (container.ports.nonEmpty) {
      val answer = prompt("apply http ports:" + container.ports.mkString(" ") + "(y/n)?")
      if ("y" == answer.toLowerCase) ports ++= container.ports
    }

    if (ports.nonEmpty) {
      val sb = new StringBuilder()
      for (port <- ports) {
        sb ++= (" --add-port=" + port + "/tcp")
      }
      val cmd = "firewall-cmd --permanent --zone=public" + sb.mkString
      if (isRoot) {
        println("executing:" + cmd)
        Runtime.getRuntime.exec(cmd)
        println("firewalld changed successfully.")
      } else {
        println("Please execute the command:\n sudo " + cmd)
      }
    }
  }

  def generate(): String = {
    val cfg = Configurator.newConfig
    cfg.setNumberFormat("0.##")
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("ports", container.ports)
    val sw = new StringWriter()
    val template = cfg.getTemplate("sas/firewall.ftl")
    template.process(data, sw)
    sw.close()
    sw.toString
  }

  def printHelp(): Unit = {
    println(
      s"""Avaliable command:
         |  info        print server port
         |  conf        generate firewall configuration
         |  apply       apply server port config to firewall
         |  help        print this help conent""".stripMargin)
  }
}
