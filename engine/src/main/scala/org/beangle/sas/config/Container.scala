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

package org.beangle.sas.config

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Numbers.toInt
import org.beangle.commons.lang.Strings.{isEmpty, isNotBlank}
import org.beangle.commons.lang.{Numbers, Strings}

object Container {

  def apply(xml: scala.xml.Elem): Container = {
    val conf = new Container
    val sasVersion = (xml \ "@version").text
    if (isEmpty(sasVersion)) {
      throw new RuntimeException("Sas missing version attribute")
    }
    conf.version = sasVersion
    conf.proxy = new Proxy

    // 1. resolve repository first
    (xml \ "Repository") foreach { repoElem =>
      val local = (repoElem \ "@local").text
      val remote = (repoElem \ "@remote").text
      conf.repository = new Repository(if (isEmpty(local)) None else Some(local), if (isEmpty(remote)) None else Some(remote))
    }
    if (null == conf.repository) {
      conf.repository = new Repository(None, None)
    }

    //2. identify engines
    (xml \ "Engines" \ "Engine") foreach { engineElem =>
      val name = (engineElem \ "@name").text
      val version = (engineElem \ "@version").text
      val typ = (engineElem \ "@type").text

      val engine = new Engine(name, typ, version)
      (engineElem \ "@jspSupport") foreach { j =>
        engine.jspSupport = j.text == "true"
      }
      (engineElem \ "@websocketSupport") foreach { j =>
        engine.websocketSupport = j.text == "true"
      }

      (engineElem \ "Listener").foreach { lsnElem =>
        val listener = new Listener((lsnElem \ "@className").text)
        for ((k, v) <- lsnElem.attributes.asAttrMap -- Set("className")) {
          listener.properties.put(k, v)
        }
        engine.listeners += listener
      }

      (engineElem \ "Context").foreach { ctxElem =>
        val context = new Context
        (ctxElem \ "Loader").foreach { ldElem =>
          val loader = new Loader((ldElem \ "@className").text)
          for ((k, v) <- ldElem.attributes.asAttrMap -- Set("className")) {
            loader.properties.put(k, v)
          }
          context.loader = loader
        }
        (ctxElem \ "JarScanner").foreach { scanElem =>
          val jarScanner = new JarScanner()
          for ((k, v) <- scanElem.attributes.asAttrMap -- Set("className")) {
            jarScanner.properties.put(k, v)
          }
          context.jarScanner = jarScanner
        }
        engine.context = context
      }

      (engineElem \ "Jar").foreach { jarElem =>
        val jar = new Jar((jarElem \ "@uri").text)
        engine.jars += jar
      }
      conf.engines += engine
    }

    // 3. collect hosts
    (xml \ "Hosts" \ "Host") foreach { hostElem =>
      val name = (hostElem \ "@name").text
      val ip = (hostElem \ "@ip").text
      val comment = (hostElem \ "@comment").text
      val host = new Host(name, ip)
      if (isNotBlank(comment)) host.comment = Some(comment)
      conf.hosts += host
    }
    if (conf.hosts.isEmpty) {
      conf.hosts.addOne(Host.Localhost)
    }

    // 4. register resources
    (xml \ "Resources" \ "Resource") foreach { resourceElem =>
      val ds = new Resource((resourceElem \ "@name").text)
      for ((k, v) <- resourceElem.attributes.asAttrMap -- Set("name")) {
        ds.properties.put(k, v)
      }
      conf.resources.put(ds.name, ds)
    }

    // 5. build all farms
    (xml \ "Farms" \ "Farm").foreach { farmElem =>
      val engine = conf.engine((farmElem \ "@engine").text)
      if (engine.isEmpty) throw new RuntimeException("Cannot find engine for" + (farmElem \ "@engine").text)

      val farm = new Farm((farmElem \ "@name").text, engine.get)
      require(!farm.name.contains("."), s"farm name ${farm.name} cannot contains .")
      val hosts = (farmElem \ "@hosts").text
      if (isEmpty(hosts)) {
        farm.hosts += Host.Localhost
      } else {
        Strings.split(hosts) foreach { host =>
          farm.hosts += conf.getHost(host)
        }
      }
      (farmElem \ "@enableAccessLog") foreach { n =>
        farm.enableAccessLog = java.lang.Boolean.valueOf(n.text)
      }
      val opts = (farmElem \ "Options").text
      farm.opts = if (isEmpty(opts)) None else Some(opts)

      (farmElem \ "Http") foreach { httpElem =>
        val http = new HttpConnector
        readHttpConnector(httpElem, http)
        farm.http = http
      }

      (farmElem \ "Http2") foreach { elem =>
        val http2 = new Http2Connector
        readHttpConnector(elem, http2)
        if ((elem \ "@caKeyFile").nonEmpty) http2.caKeyFile = (elem \ "@caKeyFile").text
        if ((elem \ "@caFile").nonEmpty) http2.caFile = (elem \ "@caFile").text
        farm.http2 = http2
      }
      (farmElem \ "Server") foreach { serverElem =>
        val server = new Server(farm, (serverElem \ "@name").text)
        server.http = toInt((serverElem \ "@http").text)
        server.http2 = toInt((serverElem \ "@http2").text)
        farm.servers += server

        val accessEnabled = serverElem \ "@enableAccessLog"
        accessEnabled foreach { n =>
          server.enableAccessLog = java.lang.Boolean.valueOf(n.text)
        }
        if (accessEnabled.isEmpty) {
          server.enableAccessLog = farm.enableAccessLog
        }
      }
      conf.farms += farm
    }

    // 6. register webapps
    (xml \ "Webapps" \ "Webapp").foreach { webappElem =>
      val app = new Webapp((webappElem \ "@name").text)
      app.uri = (webappElem \ "@uri").text
      if (ArchiveURI.isGav(app.uri) && app.uri.contains("SNAPSHOT")) {
        throw new RuntimeException("Cannot accept gav with SNAPSHOT")
      }

      for ((k, v) <- webappElem.attributes.asAttrMap -- Set("name", "uri", "reloadable")) {
        app.properties.put(k, v)
      }

      (webappElem \ "ResourceRef").foreach { dsElem =>
        app.resources += conf.resources((dsElem \ "@ref").text)
      }
      (webappElem \ "Realm").foreach { realmElem =>
        app.realms = realmElem.toString()
      }
      (webappElem \ "resolveSupport").foreach { resolveElem =>
        app.resolveSupport = resolveElem.toString().toBoolean
      }
      conf.webapps += app
    }

    //7. generate proxy and backends
    (xml \ "Proxy") foreach { proxyElem =>
      val proxy = conf.proxy
      (proxyElem \ "@maxconn") foreach { e =>
        proxy.maxconn = Integer.valueOf(e.text)
      }
      (proxyElem \ "@hostname") foreach { e =>
        proxy.hostname = Some(e.text)
      }
      (proxyElem \ "@engine") foreach { e =>
        proxy.engine = e.text
      }

      (proxyElem \ "Status") foreach { elem =>
        val stat = new Proxy.Status
        proxy.status = Some(stat)
        (elem \ "@uri") foreach { e =>
          stat.uri = e.text
        }
        (elem \ "@auth") foreach { e =>
          stat.auth = e.text
        }
      }

      (proxyElem \ "Https") foreach { elem =>
        val https = new Proxy.Https
        proxy.https = Some(https)
        (elem \ "@ciphers") foreach { e =>
          https.ciphers = e.text
        }
        (elem \ "@certificate") foreach { e =>
          https.certificate = e.text
        }
        (elem \ "@certificateKey") foreach { e =>
          https.certificateKey = e.text
        }
        (elem \ "@protocols") foreach { e =>
          https.protocols = e.text
        }
        (elem \ "@forceHttps") foreach { e =>
          https.forceHttps = java.lang.Boolean.valueOf(e.text)
        }
      }
      if (proxy.hostname.isEmpty && proxy.enableHttps) {
        throw new RuntimeException("Cannot find hostname,when https enabled")
      }

      (proxyElem \ "Backend") foreach { elem =>
        val backend = new Proxy.Backend((elem \ "@name").text)
        (elem \ "@servers") foreach { serversElem =>
          val patterns = Strings.split(serversElem.text)
          patterns foreach { pattern =>
            backend.addServers(pattern, conf)
          }
        }
        //添加或更新主机
        (elem \ "Server") foreach { selem =>
          val serverName = (selem \ "@name").text
          val serverHost = (selem \ "@host").text
          val serverList = Collections.newBuffer[Proxy.Server]
          conf.getServer(serverName) match {
            case Some(s) =>
              if (Strings.isNotEmpty(serverHost)) {
                if (!s.farm.hosts.exists(_.name == serverHost)) {
                  throw new RuntimeException(s"Cannot find server host $serverHost in ${s.farm.name}'s hosts.")
                }
              }
              s.farm.hosts foreach { h =>
                if (Strings.isEmpty(serverHost) || serverHost == h.name) {
                  serverList += backend.addServer(serverName, h.ip, s.http, None)
                }
              }
            case None => throw new RuntimeException(s"Cannot find server $serverName,Server name's pattern is {farm}.{server}.")
          }
          (selem \ "@options") foreach { e =>
            serverList foreach { s =>
              s.options = Some(e.text)
            }
          }
          (selem \ "@port") foreach { e =>
            val p = Numbers.toInt(e.text)
            serverList foreach { s =>
              s.port = p
            }
          }
        }
        (elem \ "Options") foreach { selem =>
          backend.options = Some(trimlines(selem.text))
        }
        proxy.addBackend(backend)
      }
    }

    //8. scan all deployments
    (xml \ "Deployments" \ "Deployment") foreach { deployElem =>
      var path = (deployElem \ "@path").text
      if (path == "/") {
        path = ""
      }
      val backend = (deployElem \ "@on").text
      val deployment = new Deployment((deployElem \ "@webapp").text, backend, path)

      (deployElem \ "@unpack") foreach { u =>
        deployment.unpack = Some(u.text.toBoolean)
      }
      (deployElem \ "@reloadable") foreach { u =>
        deployment.reloadable = u.text.toBoolean
      }
      conf.proxy.getOrCreateBackend(backend, conf)
      conf.deployments += deployment
    }

    conf
  }

  private def trimlines(content: String): String = {
    Strings.split(content, '\n').map(_.trim).mkString("\n")
  }

  private def readHttpConnector(elem: scala.xml.Node, http: HttpConnector): Unit = {
    if ((elem \ "@enableLookups").nonEmpty) http.enableLookups = (elem \ "@enableLookups").text == "true"
    if ((elem \ "@acceptCount").nonEmpty) http.acceptCount = Some(toInt((elem \ "@acceptCount").text))
    if ((elem \ "@maxThreads").nonEmpty) http.maxThreads = toInt((elem \ "@maxThreads").text)
    if ((elem \ "@maxConnections").nonEmpty) http.maxConnections = Some(toInt((elem \ "@maxConnections").text))
    if ((elem \ "@minSpareThreads").nonEmpty) http.minSpareThreads = toInt((elem \ "@minSpareThreads").text)

    if ((elem \ "@disableUploadTimeout").nonEmpty) http.disableUploadTimeout = (elem \ "@disableUploadTimeout").text == "true"
    if ((elem \ "@connectionTimeout").nonEmpty) http.connectionTimeout = toInt((elem \ "@connectionTimeout").text)
    if ((elem \ "@compression").nonEmpty) http.compression = (elem \ "@compression").text
    if ((elem \ "@compressionMinSize").nonEmpty) http.compressionMinSize = toInt((elem \ "@compressionMinSize").text)
    if ((elem \ "@compressionMimeType").nonEmpty) http.compressionMimeType = (elem \ "@compressionMimeType").text
  }

}

class Container {

  var version: String = _

  var repository: Repository = _

  var proxy: Proxy = _

  val engines = new collection.mutable.ListBuffer[Engine]

  val hosts = new collection.mutable.ListBuffer[Host]

  val farms = new collection.mutable.ListBuffer[Farm]

  val webapps = new collection.mutable.ListBuffer[Webapp]

  val resources = new collection.mutable.HashMap[String, Resource]

  val deployments = new collection.mutable.ListBuffer[Deployment]

  def webappNames: Set[String] = {
    webapps.map(c => c.name).toSet
  }

  def resourceNames: Set[String] = {
    resources.keySet.toSet
  }

  def engine(name: String): Option[Engine] = {
    engines.find(e => e.name == name)
  }

  def farmResourceNames(farm: Farm): Set[String] = {
    val names = new collection.mutable.HashSet[String]
    deployments foreach { d =>
      if (d.on == farm.name || d.on.startsWith(farm.name + ".")) {
        webapps find (w => w.name == d.webapp) foreach { w => names ++= w.resourceNames }
      }
    }
    names.toSet
  }

  def farmNames: Set[String] = farms.map(f => f.name).toSet

  def serverNames: Seq[String] = {
    farms.flatMap(_.servers).map(s => s.farm.name + "." + s.name).toSeq
  }

  def ports: List[Int] = {
    val ports = new collection.mutable.HashSet[Int]
    for (farm <- farms; server <- farm.servers) {
      if (server.http > 0) ports += server.http
    }
    ports.toList.sorted
  }

  def getServer(name: String): Option[Server] = {
    val res = new collection.mutable.ArrayBuffer[Server]
    farms foreach { x =>
      res ++= x.servers.find(_.qualifiedName == name)
    }
    res.headOption
  }

  def getMatchedServers(pattern: String): List[Server] = {
    val res = new collection.mutable.ArrayBuffer[Server]
    val patterns = pattern.split(",")
    farms foreach { x =>
      x.servers foreach { server =>
        val fullname = server.qualifiedName
        val matched = patterns.exists(one => one == fullname || fullname.startsWith(one + "."))
        if (matched) {
          res += server
        }
      }
    }
    res.toList
  }

  def getHost(name: String): Host = {
    hosts.find(_.name == name).get
  }

  def getWebapp(name: String): Option[Webapp] = {
    webapps.find(_.name == name)
  }

  def getDeployments(server: Server, ips: collection.Set[String]): Seq[Deployment] = {
    deployments.filter { d =>
      ips.exists { ip =>
        proxy.getBackend(d.on).contains(server.qualifiedName, ip)
      }
    }.toSeq
  }

  def getWebapps(server: Server, ips: collection.Set[String]): Seq[Webapp] = {
    val webappMap = webapps.map(x => (x.name, x)).toMap
    val serverApps = Collections.newBuffer[Webapp]
    deployments.foreach { d =>
      val suitable = ips.exists { ip =>
        proxy.getBackend(d.on).contains(server.qualifiedName, ip)
      }
      if (suitable) {
        webappMap.get(d.webapp) foreach { w =>
          serverApps += w
        }
      }
    }
    serverApps.toSeq
  }

  def hasExternHost: Boolean = {
    hosts.exists { h => h.ip != "127.0.0.1" && h.ip != "localhost" }
  }

}
