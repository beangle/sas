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

package org.beangle.sas.server

import java.io.{File, FileInputStream, FileOutputStream}
import java.net.{Inet4Address, NetworkInterface, URL}
import java.time.LocalDate
import java.time.format.DateTimeFormatter

import freemarker.template.Configuration
import org.beangle.commons.collection.Collections
import org.beangle.commons.io.{Files, IOs}
import org.beangle.commons.lang.Strings
import org.beangle.commons.lang.Strings.substringAfterLast
import org.beangle.sas.daemon.ServerStatus
import org.beangle.sas.model.{Container, Server}
import org.beangle.template.freemarker.Configurer

object SasTool {

  val templateCfg = Configurer.newConfig
  templateCfg.setTagSyntax(Configuration.SQUARE_BRACKET_TAG_SYNTAX)
  templateCfg.setDefaultEncoding("UTF-8")
  templateCfg.setNumberFormat("0.##")

  def detectExecution(server: Server): Option[ServerStatus] = {
    val p = new ProcessBuilder("lsof", "-i", ":" + server.http).start()
    val res = IOs.readString(p.getInputStream)
    if (Strings.isNotBlank(res)) {
      val lines = Strings.split(res.trim(), "\n")
      if (lines.length > 1) {
        // java pid ....
        val elems = Strings.split(lines(1), " ")
        val pid = elems(1) //ps -f -p $PID
        val ps = new ProcessBuilder("ps", "-f", "-p", pid.trim).start()
        Some(new ServerStatus(pid.toInt, IOs.readString(ps.getInputStream)))
      } else {
        None
      }
    } else {
      None
    }
  }

  def rollLog(sasHome: String, container: Container, server: Server): Unit = {
    val d = LocalDate.now()
    val consoleOut = new File(sasHome + "/servers/" + server.qualifiedName + "/logs/console.out")
    if (consoleOut.exists()) {
      val archive = new File(sasHome + "/logs/archive/" + server.qualifiedName + s"-${d.format(DateTimeFormatter.ofPattern("yyyyMMdd"))}.out")
      if (!archive.exists()) {
        Files.touch(archive)
      }
      val os = Files.writeOpen(archive, true)
      val is = new FileInputStream(consoleOut)
      IOs.copy(is, os)
      IOs.close(is, os)
      consoleOut.delete()
    }
    Files.touch(consoleOut)
  }

  def download(url: String, dir: String): String = {
    val fileName = substringAfterLast(url, "/")
    val destFile = new File(dir + fileName)
    if (!destFile.exists) {
      val destOs = new FileOutputStream(destFile)
      val warurl = new URL(url)
      IOs.copy(warurl.openStream(), destOs)
      destOs.close()
    }
    fileName
  }

  def getLocalIPs(): Set[String] = {
    val niEnum = NetworkInterface.getNetworkInterfaces
    val ips = Collections.newBuffer[String]("127.0.0.1")
    while (niEnum.hasMoreElements) {
      val ni = niEnum.nextElement()
      if (ni.isUp && !ni.isLoopback) {
        val ipEnum = ni.getInetAddresses
        while (ipEnum.hasMoreElements) {
          ipEnum.nextElement() match {
            case ip: Inet4Address => ips += ip.getHostAddress
            case _ =>
          }
        }
      }
    }
    ips.toSet
  }
}
