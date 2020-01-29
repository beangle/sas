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

object Haproxy {

  def getDefault: Haproxy = {
    val proxy = new Haproxy()
    proxy.global =
      """log         127.0.0.1 local2
        |chroot      /var/lib/haproxy
        |pidfile     /var/run/haproxy.pid
        |maxconn     ${maxconn}
        |user        haproxy
        |group       haproxy
        |daemon
        |tune.ssl.default-dh-param 2048
        |ssl-default-bind-options no-sslv3 no-tlsv10
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
        |maxconn                 ${maxconn}""".stripMargin

    proxy
  }

  class Stat {
    var auth: String = "admin:ChangeItNow"
    var uri: String = "/stats"
  }

  class Https {
    var pem = "/etc/haproxy/server.pem"
    var ciphers = "TLSv1+HIGH:!aNULL:!eNULL:!3DES:!RC4:!CAMELLIA:!DH:!kECDHE:@STRENGTH no-sslv3 no-tlsv10"
    var port = 443
  }

}

import org.beangle.sas.model.Haproxy.{Https, Stat}

class Haproxy extends Proxy {
  /** 全局设置 */
  var global: String = _
  /** 默认设置 */
  var defaults: String = _
  /** 前端设置 */
  var frontend: String = _
  /** 统计状态设置 */
  var stat: Option[Stat] = None
  /** https配置 */
  var https: Option[Https] = None

  def init(): Unit = {
    this.global = process(this.global)
    this.defaults = process(this.defaults)
    if (null == this.frontend) {
      this.frontend = genFrontend()
    }
    this.frontend = process(this.frontend)
  }

  def genFrontend(): String = {
    if (this.enableHttps) {
      """bind *:80
        |bind *:${https.port} ssl crt ${https.pem} ciphers ${https.ciphers}
        |http-request set-header X-Forwarded-Proto https if { ssl_fc }
        |http-request set-header X-Forwarded-Port %[dst_port]
        |acl is_me hdr_beg(host) ${hostname}
        |redirect scheme https if !{ ssl_fc } is_me""".stripMargin
    } else {
      "bind *:80"
    }
  }

  def genStat(): String = {
    stat match {
      case None => ""
      case Some(_) =>
        process(
          """stats socket /var/lib/haproxy/stats
            |stats refresh 30s
            |stats uri ${stat.uri}
            |stats realm haproxy-user
            |stats auth ${stat.auth}""".stripMargin)
    }
  }
}

