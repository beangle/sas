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
package org.beangle.sas.model

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings

import scala.collection.mutable

object Haproxy {

  def getDefault: Haproxy = {
    val proxy = new Haproxy()
    proxy.global =
      """log         127.0.0.1 local2
        |chroot      /var/lib/haproxy
        |pidfile     /var/run/haproxy.pid
        |maxconn     15000
        |user        haproxy
        |group       haproxy
        |daemon
        |tune.ssl.default-dh-param 2048
        |ssl-default-bind-options no-sslv3 no-tlsv10
        |stats socket /var/lib/haproxy/stats
        |ssl-default-bind-ciphers PROFILE=SYSTEM
        |ssl-default-server-ciphers PROFILE=SYSTEM""".stripMargin

    proxy.defaults =
      """mode                    http
        |log                     global
        |option                  httplog
        |option                  dontlognull
        |option http-server-close
        |option forwardfor       except 127.0.0.0/8
        |option                  redispatch
        |retries                 3
        |timeout http-request    2m
        |timeout queue           1m
        |timeout connect         30s
        |timeout client          2m
        |timeout server          10m
        |timeout http-keep-alive 60s
        |timeout check           60s
        |maxconn                 15000
        |
        |stats refresh 30s
        |stats uri  /stats
        |stats realm haproxy-user
        |stats auth admin:ChangeItNow""".stripMargin

    proxy.frontend =
      """bind *:80
        |bind *:443 ssl crt /etc/haproxy/server.pem ciphers TLSv1+HIGH:!aNULL:!eNULL:!3DES:!RC4:!CAMELLIA:!DH:!kECDHE:@STRENGTH no-sslv3 no-tlsv10
        |http-request set-header X-Forwarded-Proto https if { ssl_fc }
        |http-request set-header X-Forwarded-Port %[dst_port]
        |redirect scheme https if !{ ssl_fc }""".stripMargin

    proxy
  }
}

class Haproxy {
  var global: String = _
  var defaults: String = _
  var frontend: String = _
  val backends: mutable.Map[String, Backend] = Collections.newMap[String, Backend]

  def getBackend(backendName: String): Backend = {
    var name = backendName
    name = Strings.replace(name, ",", "_")
    name = Strings.replace(name, ".", "_")
    backends.get(name) match {
      case None =>
        val backend = new Backend(name, backendName)
        backend.options = "balance roundrobin"
        backends.put(name, backend)
        backend
      case Some(b) => b
    }
  }

  def addBackend(backend: Backend): this.type = {
    backends.put(backend.name, backend)
    this
  }
}

class Backend(var name: String, var servers: String) {
  var options: String = _

  def getServers(container: Container): List[Server] = {
    container.getMatchedServers(servers)
  }

  def contains(server: Server): Boolean = {
    val sname = server.qualifiedName
    if (sname == servers) {
      true
    } else {
      val res = servers.split(",") find (one => one == sname || sname.startsWith(one + "."))
      res.isDefined
    }
  }
}
