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

import scala.collection.mutable

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
    if null == conf.repository then conf.repository = new Repository(None, None)

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
      conf.hosts += new Host(name, ip)
    }
    if conf.hosts.isEmpty then conf.hosts.addOne(Host.Localhost)

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
      require(!farm.name.contains("."), s"farm name ${farm.name} cannot contains dot")
      val maxHeapSize = (farmElem \ "@maxHeapSize").text
      farm.maxHeapSize = if isEmpty(maxHeapSize) then "300M" else maxHeapSize
      (farmElem \ "@enableAccessLog") foreach { n =>
        farm.enableAccessLog = java.lang.Boolean.valueOf(n.text)
      }
      val serverOpts = (farmElem \ "ServerOptions").text
      farm.serverOptions = if (isEmpty(serverOpts)) None else Some(serverOpts)
      val proxyOpts = (farmElem \ "ProxyOptions").text
      farm.proxyOptions = if (isEmpty(proxyOpts)) None else Some(proxyOpts)

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
      (farmElem \ "ProxyOptions") foreach { selem =>
        farm.proxyOptions = Some(trimlines(selem.text))
      }
      (farmElem \ "Server") foreach { serverElem =>
        val server = new Server(farm, (serverElem \ "@name").text)
        server.http = toInt((serverElem \ "@http").text)
        server.http2 = toInt((serverElem \ "@http2").text)
        farm.servers += server

        val host = (serverElem \ "@host").text
        server.host = if isEmpty(host) then Host.Localhost else conf.getHost(host)

        val accessEnabled = serverElem \ "@enableAccessLog"
        accessEnabled foreach { n =>
          server.enableAccessLog = java.lang.Boolean.valueOf(n.text)
        }
        if accessEnabled.isEmpty then server.enableAccessLog = farm.enableAccessLog

        val maxHeapSize = (serverElem \ "@maxHeapSize").text
        server.maxHeapSize = if isEmpty(maxHeapSize) then farm.maxHeapSize else maxHeapSize

        val proxyOpts = (serverElem \ "@proxyOptions").text
        server.proxyOptions = if (isEmpty(proxyOpts)) None else Some(proxyOpts)

        (serverElem \ "@proxyHttpPort") foreach { p =>
          server.proxyHttpPort = Some(p.text.toInt)
        }
      }
      conf.farms += farm
    }

    // 6. register webapps and deployments
    (xml \ "Webapps" \ "Webapp").foreach { webappElem =>
      val app = new Webapp((webappElem \ "@uri").text)
      for ((k, v) <- webappElem.attributes.asAttrMap -- Set("name", "uri", "reloadable", "path", "runAt", "docBase")) {
        app.properties.put(k, v)
      }

      (webappElem \ "ResourceRef").foreach { dsElem => app.resources += conf.resources((dsElem \ "@ref").text) }
      (webappElem \ "Realm").foreach { realmElem =>
        app.realms = realmElem.toString()
      }
      (webappElem \ "resolveSupport").foreach { resolveElem => app.resolveSupport = resolveElem.toString().toBoolean }
      app.updatePath((webappElem \ "@path").text)
      val runAt = (webappElem \ "@runAt").text
      Strings.split(runAt) foreach { s =>
        conf.farms.find(x => x.name == s) match {
          case Some(f) =>
            app.runAt ++= f.servers
          case None =>
            conf.getServer(s) match {
              case Some(server) => app.runAt += server
              case None => throw new RuntimeException(s"Cannot find server named ${s}")
            }
        }
      }
      (webappElem \ "@unpack") foreach { u => app.unpack = Some(u.text.toBoolean) }
      conf.webapps += app
    }

    //7. generate front proxy and backends
    (xml \ "Proxy") foreach { proxyElem =>
      val proxy = conf.proxy
      (proxyElem \ "@maxconn") foreach { e => proxy.maxconn = Integer.valueOf(e.text) }
      (proxyElem \ "@hostname") foreach { e => proxy.hostname = Some(e.text) }
      (proxyElem \ "@engine") foreach { e => proxy.engine = e.text }
      (proxyElem \ "@httpPort") foreach { e => proxy.httpPort = Integer.valueOf(e.text) }

      (proxyElem \ "Status") foreach { elem =>
        val stat = new Proxy.Status
        proxy.status = Some(stat)
        (elem \ "@uri") foreach { e => stat.uri = e.text }
        (elem \ "@auth") foreach { e => stat.auth = e.text }
      }

      (proxyElem \ "Https") foreach { elem =>
        val https = new Proxy.Https
        proxy.https = Some(https)
        (elem \ "@ciphers") foreach { e => https.ciphers = e.text }
        (elem \ "@certificate") foreach { e => https.certificate = e.text }
        (elem \ "@certificateKey") foreach { e => https.certificateKey = e.text }
        (elem \ "@protocols") foreach { e => https.protocols = e.text }
        (elem \ "@forceHttps") foreach { e => https.forceHttps = java.lang.Boolean.valueOf(e.text) }
        (elem \ "@port") foreach { e => https.port = java.lang.Integer.valueOf(e.text) }
      }
      if (proxy.hostname.isEmpty && proxy.enableHttps) {
        throw new RuntimeException("Cannot find hostname,when https enabled")
      }

      val backends = new mutable.HashMap[Farm, mutable.HashSet[Set[Server]]]
      val backendMapping = new mutable.HashMap[Set[Server], mutable.HashSet[Webapp]]
      conf.webapps foreach { webapp =>
        if webapp.runAt.nonEmpty then
          val farm = webapp.runAt.head.farm
          val servers = webapp.runAt.toSet
          val farmBackends = backends.getOrElseUpdate(farm, new mutable.HashSet[Set[Server]])
          farmBackends.addOne(servers)
          backendMapping.getOrElseUpdate(servers, new mutable.HashSet[Webapp]).addOne(webapp)
      }
      backends foreach { case (farm, serverLists) =>
        var i = 1
        val farmBackends = serverLists map { servers =>
          val backendName =
            if servers.size == 1 then
              servers.head.qualifiedName.replace('.', '_')
            else
              i = i + 1
              s"${farm.name}$i"
          val backend = new Proxy.Backend(backendName)
          servers foreach { s => backend.addServer(s.name, s.host.ip, s.proxyHttpPort.getOrElse(s.http), s.proxyOptions) }

          backend.options = farm.proxyOptions
          proxy.addBackend(backend)
          backendMapping(servers) foreach { webapp => webapp.entryPoint = backend }
          backend
        }
        if farmBackends.size == 1 then farmBackends.head.name = farm.name
      }
    }

    conf
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

  private def trimlines(content: String): String = {
    Strings.split(content, '\n').map(_.trim).mkString("\n")
  }
}

class Container {

  val engines = new collection.mutable.ListBuffer[Engine]
  val hosts = new collection.mutable.ListBuffer[Host]
  val farms = new collection.mutable.ListBuffer[Farm]
  val webapps = new collection.mutable.ListBuffer[Webapp]
  val resources = new collection.mutable.HashMap[String, Resource]
  var version: String = _
  var repository: Repository = _
  var proxy: Proxy = _

  /** 可运行的webapp
   * 过滤掉webapp没有entryPoint的应用，并按照上下文排序，根放在最后
   *
   * @return
   */
  def runnableWebapps: Seq[Webapp] = {
    var runables = webapps.filter(_.entryPoint != null)
    runables = runables.sortBy(w => w.contextPath)
    val roots = runables.filter(_.contextPath.length < 2)
    (runables.subtractAll(roots) ++ roots).toSeq
  }

  def resourceNames: Set[String] = {
    resources.keySet.toSet
  }

  def engine(name: String): Option[Engine] = {
    engines.find(e => e.name == name)
  }

  def farmResourceNames(farm: Farm): Set[String] = {
    val names = new collection.mutable.HashSet[String]
    webapps foreach { webapp =>
      if webapp.runAt.nonEmpty && webapp.runAt.head.farm == farm then names ++= webapp.resourceNames
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
    farms foreach { x => res ++= x.servers.find(_.qualifiedName == name) }
    res.headOption
  }

  def getMatchedServers(pattern: String): List[Server] = {
    val res = new collection.mutable.ArrayBuffer[Server]
    val patterns = pattern.split(",")
    farms foreach { x =>
      x.servers foreach { server =>
        val fullname = server.qualifiedName
        val matched = patterns.exists(one => one == fullname || fullname.startsWith(one + "."))
        if matched then res += server
      }
    }
    res.toList
  }

  def getHost(name: String): Host = {
    hosts.find(_.name == name).get
  }

  def getWebapps(server: Server): Seq[Webapp] = {
    val serverApps = Collections.newBuffer[Webapp]
    webapps.foreach { webapp =>
      if webapp.runAt.contains(server) then serverApps += webapp
    }
    serverApps.toSeq
  }

  def hasExternHost: Boolean = {
    hosts.exists { h => h.ip != "127.0.0.1" && h.ip != "localhost" }
  }
}
