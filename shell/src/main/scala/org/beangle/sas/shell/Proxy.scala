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

package org.beangle.sas.shell

import org.beangle.commons.lang.SystemInfo
import org.beangle.sas.proxy.ProxyGenerator

object Proxy extends ShellEnv {
  def main(args: Array[String]): Unit = {
    workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    read()
    container.proxy.engine match {
      case "haproxy" =>
        val file = ProxyGenerator.genHaproxy(container, workdir)
        println(s"Generate ${workdir}/conf/haproxy.cfg")
        println("Execute:\n    cp " + file.getAbsolutePath + " /etc/haproxy/haproxy.cfg")
      case "nginx" =>
        val file = ProxyGenerator.genNginx(container, workdir)
        println(s"Generate ${workdir}/conf/nginx.conf")
        println("Execute:\n    cp " + file.getAbsolutePath + " /etc/nginx/nginx.conf")
      case _ =>
        println("only support haproxy and nginx.")
    }

  }
}
