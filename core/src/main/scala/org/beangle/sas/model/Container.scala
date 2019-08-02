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

import org.beangle.sas.util.Strings.{isEmpty, isNotBlank, isNotEmpty, toInt}

object Container {

  def apply(xml: scala.xml.Elem): Container = {
    val conf = new Container
    val sasVersion = (xml \ "@version").text
    if (isEmpty(sasVersion)) {
      throw new RuntimeException("Sas missing version attribute")
    }
    conf.version = sasVersion

    (xml \ "Repository") foreach { repoElem =>
      val local = (repoElem \ "@local").text
      val remote = (repoElem \ "@remote").text
      conf.repository = new Repository(if (isEmpty(local)) None else Some(local), if (isEmpty(remote)) None else Some(remote))
    }

    (xml \ "Engines" \ "Engine") foreach { engineElem =>
      val name = (engineElem \ "@name").text
      val version = (engineElem \ "@version").text
      val typ = (engineElem \ "@type").text
      val jspSupport = (engineElem \ "@jspSupport").text

      val engine = new Engine(name, typ, version)
      engine.jspSupport = jspSupport == "true"

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
        val jar = new Jar
        val gav = (jarElem \ "@gav").text
        val url = (jarElem \ "@url").text
        val path = (jarElem \ "@path").text

        if (isNotBlank(gav)) jar.gav = Some(gav)
        if (isNotBlank(url)) jar.url = Some(url)
        if (isNotBlank(path)) jar.path = Some(path)
        engine.jars += jar
      }
      conf.engines += engine
    }

    (xml \ "Hosts" \ "Host") foreach { hostElem =>
      val name = (hostElem \ "@name").text
      val ip = (hostElem \ "@ip").text
      val comment = (hostElem \ "@comment").text
      val host = new Host(name, ip)
      if (isNotBlank(comment)) host.comment = Some(comment)
      conf.hosts += host
    }

    (xml \ "Farms" \ "Farm").foreach { farmElem =>
      val engine = conf.engine((farmElem \ "@engine").text)
      if (engine.isEmpty) throw new RuntimeException("Cannot find engine for" + (farmElem \ "@engine").text)

      val farm = new Farm((farmElem \ "@name").text, engine.get)
      val jvmopts = (farmElem \ "JvmArgs" \ "@opts").text
      farm.jvmopts = if (isEmpty(jvmopts)) None else Some(jvmopts)

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
        val host = (serverElem \ "@host").text
        if (isNotEmpty(host)) server.host = Some(host)
        farm.servers += server
      }
      conf.farms += farm
    }

    (xml \ "Resources" \ "Resource") foreach { resourceElem =>
      val ds = new Resource((resourceElem \ "@name").text)
      for ((k, v) <- resourceElem.attributes.asAttrMap -- Set("name")) {
        ds.properties.put(k, v)
      }
      conf.resources.put(ds.name, ds)
    }

    (xml \ "Webapps" \ "Webapp").foreach { webappElem =>
      val context = new Webapp((webappElem \ "@name").text)
      if ((webappElem \ "@reloadable").nonEmpty) context.reloadable = (webappElem \ "@reloadable").text == "true"
      if ((webappElem \ "@docBase").nonEmpty) context.docBase = (webappElem \ "@docBase").text
      if ((webappElem \ "@url").nonEmpty) context.url = (webappElem \ "@url").text
      if ((webappElem \ "@gav").nonEmpty) context.gav = (webappElem \ "@gav").text

      for ((k, v) <- webappElem.attributes.asAttrMap -- Set("name", "docBase", "reloadable", "url", "gav")) {
        context.properties.put(k, v)
      }

      (webappElem \ "ResourceRef").foreach { dsElem =>
        context.resources += conf.resources((dsElem \ "@ref").text)
      }
      (webappElem \ "Realm").foreach { realmElem =>
        context.realms = realmElem.toString()
      }
      conf.webapps += context
    }

    (xml \ "Deployments" \ "Deployment") foreach { deployElem =>
      conf.deployments += new Deployment((deployElem \ "@webapp").text, (deployElem \ "@on").text, (deployElem \ "@path").text)
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

  def applyDefault(conf: Container): Unit = {
    if (null == conf.repository) {
      conf.repository = new Repository(None, None)
    }
    conf.engines foreach { engine =>
      if (engine.typ == EngineType.Tomcat) {
        if (engine.listeners.isEmpty) {
          engine.listeners += new Listener("org.apache.catalina.core.AprLifecycleListener").property("SSLEngine", "on")
          engine.listeners += new Listener("org.apache.catalina.core.JreMemoryLeakPreventionListener")
          engine.listeners += new Listener("org.apache.catalina.mbeans.GlobalResourcesLifecycleListener")
          engine.listeners += new Listener("org.apache.catalina.core.ThreadLocalLeakPreventionListener")
        }

        if (null == engine.context) engine.context = new Context()

        val context = engine.context
        if (context.loader == null) {
          context.loader = new Loader("org.apache.catalina.loader.RepositoryLoader")
        }
        if (context.jarScanner == null) {
          val scanner = new JarScanner
          scanner.properties.put("scanBootstrapClassPath", "false")
          scanner.properties.put("scanAllDirectories", "false")
          scanner.properties.put("scanAllFiles", "false")
          scanner.properties.put("scanClassPath", "false")
          context.jarScanner = scanner
        }
        engine.jars += Jar.gav("org.beangle.sas:beangle-sas-core:" + conf.version)
      }
    }
  }
}

class Container {

  var version: String = _

  var repository: Repository = _

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

  def getDeployments(serverName: String): Seq[Deployment] = {
    deployments.filter(_.matches(serverName)).toSeq
  }

  def hasExternHost: Boolean = {
    hosts.exists { h => h.ip != "127.0.0.1" && h.ip != "localhost" }
  }

}
