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
package org.beangle.tomcat.configurer.model

import org.beangle.commons.lang.Numbers.toInt

object Container {
  def apply(xml: scala.xml.Elem): Container = {
    val conf = new Container
    conf.version = (xml \ "@version").text
    (xml \ "Listener").foreach { lsnElem =>
      val listener = new Listener((lsnElem \ "@className").text)
      for ((k, v) <- (lsnElem.attributes.asAttrMap -- Set("className"))) {
        listener.properties.put(k, v)
      }
      conf.listeners += listener
    }

    (xml \ "Context").foreach { ctxElem =>
      conf.context = new Context
      (ctxElem \ "Loader").foreach { ldElem =>
        val loader = new Loader((ldElem \ "@className").text)
        for ((k, v) <- (ldElem.attributes.asAttrMap -- Set("className"))) {
          loader.properties.put(k, v)
        }
        conf.context.loader = loader
      }
      (ctxElem \ "JarScanner").foreach { scanElem =>
        val jarScanner = new JarScanner()
        for ((k, v) <- (scanElem.attributes.asAttrMap -- Set("className"))) {
          jarScanner.properties.put(k, v)
        }
        conf.context.jarScanner = jarScanner
      }
    }

    (xml \ "Farm").foreach { farmElem =>
      val farm = new Farm((farmElem \ "@name").text)
      farm.jvmopts = (farmElem \ "JvmArgs" \ "@opts").text

      (farmElem \ "HttpConnector") foreach { httpElem =>
        val http = new HttpConnector
        readConnector(httpElem, http)
        readHttpAndAjpConnector(httpElem, http)
        if (!(httpElem \ "@disableUploadTimeout").isEmpty) http.disableUploadTimeout = (httpElem \ "@disableUploadTimeout").text == "true"
        if (!(httpElem \ "@connectionTimeout").isEmpty) http.connectionTimeout = toInt((httpElem \ "@connectionTimeout").text)
        if (!(httpElem \ "@compression").isEmpty) http.compression = (httpElem \ "@compression").text
        if (!(httpElem \ "@compressionMinSize").isEmpty) http.compressionMinSize = toInt((httpElem \ "@compressionMinSize").text)
        if (!(httpElem \ "@compressionMimeType").isEmpty) http.compressionMimeType = (httpElem \ "@compressionMimeType").text
        farm.http = http
      }

      (farmElem \ "AjpConnector") foreach { httpElem =>
        val ajp = new AjpConnector
        readConnector(httpElem, ajp)
        readHttpAndAjpConnector(httpElem, ajp)
        farm.ajp = ajp
      }

      (farmElem \ "HttpsConnector") foreach { httpsElem =>
        val https = new HttpsConnector
        readConnector(httpsElem, https)
        readHttpAndAjpConnector(httpsElem, https)
        val properties = httpsElem.attributes.asAttrMap -- Set("protocol", "URIEncoding", "redirectPort", "enableLookups",
          "acceptCount", "maxThreads", "maxConnections", "minSpareThreads")
        for ((k, v) <- properties) {
          https.properties.put(k, v)
        }
        farm.https = https
      }

      (farmElem \ "Server") foreach { serverElem =>
        val server = new Server(farm, (serverElem \ "@name").text, toInt((serverElem \ "@shutdown").text))
        server.httpPort = toInt((serverElem \ "@http").text)
        server.httpsPort = toInt((serverElem \ "@https").text)
        server.ajpPort = toInt((serverElem \ "@ajp").text)
        farm.servers += server
      }
      conf.farms += farm
    }

    (xml \ "Resources") foreach { resourceElem =>
      (resourceElem \ "Resource").foreach { dsElem =>
        val ds = new Resource((dsElem \ "@name").text)
        for ((k, v) <- (dsElem.attributes.asAttrMap -- Set("name"))) {
          ds.properties.put(k, v)
        }
        conf.resources.put(ds.name, ds)
      }
    }

    (xml \ "Webapps").foreach { webappElem =>
      //      conf.webapp.base = (webappElem \ "@base").text
      (webappElem \ "Webapp").foreach { contextElem =>
        val context = new Webapp((contextElem \ "@name").text)
        if (!(contextElem \ "@reloadable").isEmpty) context.reloadable = (contextElem \ "@reloadable").text == "true"
        if (!(contextElem \ "@docBase").isEmpty) context.docBase = (contextElem \ "@docBase").text

        (contextElem \ "ResourceRef").foreach { dsElem =>
          context.resources += conf.resources((dsElem \ "@ref").text)
        }
        conf.webapps += context
      }
    }

    (xml \ "Deployments") foreach { deploymentElem =>
      (deploymentElem \ "Deployment").foreach { deployElem =>
        conf.deployments += new Deployment((deployElem \ "@webapp").text, (deployElem \ "@on").text, (deployElem \ "@path").text)
      }
    }
    conf
  }

  private def readConnector(xml: scala.xml.Node, connector: Connector) {
    if (!(xml \ "@protocol").isEmpty) connector.protocol = (xml \ "@protocol").text
    if (!(xml \ "@URIEncoding").isEmpty) connector.URIEncoding = (xml \ "@URIEncoding").text
    if (!(xml \ "@redirectPort").isEmpty) connector.redirectPort = Some(toInt((xml \ "@redirectPort").text))
    if (!(xml \ "@enableLookups").isEmpty) connector.enableLookups = (xml \ "@enableLookups").text == "true"
  }

  private def readHttpAndAjpConnector(xml: scala.xml.Node, connector: HttpAndAjp) {
    if (!(xml \ "@acceptCount").isEmpty) connector.acceptCount = toInt((xml \ "@acceptCount").text)
    if (!(xml \ "@maxThreads").isEmpty) connector.maxThreads = toInt((xml \ "@maxThreads").text)
    if (!(xml \ "@maxConnections").isEmpty) connector.maxConnections = Some(toInt((xml \ "@maxConnections").text))
    if (!(xml \ "@minSpareThreads").isEmpty) connector.minSpareThreads = toInt((xml \ "@minSpareThreads").text)
  }
}
class Container {

  var version = "8.0.17"

  var context: Context = _

  val listeners = new collection.mutable.ListBuffer[Listener]

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

  def farmNames: Set[String] = farms.map(f => f.name).toSet

  def serverNames: Seq[String] = farms.map(f => f.servers).flatten.map(s => s.farm.name + "." + s.name)

  def ports: List[Int] = {
    val ports = new collection.mutable.HashSet[Int]
    for (farm <- farms; server <- farm.servers) {
      if (server.httpPort > 0) ports += server.httpPort
      if (server.httpsPort > 0) ports += server.httpsPort
      if (server.ajpPort > 0) ports += server.ajpPort
    }
    ports.toList.sorted
  }

  def httpPorts: Set[Int] = {
    val httpPorts = new collection.mutable.HashSet[Int]
    for (farm <- farms; server <- farm.servers) {
      if (server.httpPort > 0) httpPorts += server.httpPort
    }
    httpPorts.toSet
  }

  def httpsPorts: Set[Int] = {
    val httpsPorts = new collection.mutable.HashSet[Int]
    for (farm <- farms; server <- farm.servers) {
      if (server.httpsPort > 0) httpsPorts += server.httpsPort
    }
    httpsPorts.toSet
  }

  def ajpPorts: Set[Int] = {
    val ajpPorts = new collection.mutable.HashSet[Int]
    for (farm <- farms; server <- farm.servers) {
      if (server.ajpPort > 0) ajpPorts += server.ajpPort
    }
    ajpPorts.toSet
  }
}