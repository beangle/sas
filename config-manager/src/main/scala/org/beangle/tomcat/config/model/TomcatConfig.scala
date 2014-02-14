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
package org.beangle.tomcat.config.model

import org.beangle.commons.lang.Numbers.toInt

object TomcatConfig {
  def apply(xml: scala.xml.Elem): TomcatConfig = {
    val conf = new TomcatConfig
    conf.version = (xml \ "@version").text

    (xml \ "farm").foreach { farmElem =>
      val farm = new Farm((farmElem \ "@name").text)
      farm.jvmopts = (farmElem \ "jvm" \ "@opts").text

      (farmElem \ "http") foreach { httpElem =>
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

      (farmElem \ "ajp") foreach { httpElem =>
        val ajp = new AjpConnector
        readConnector(httpElem, ajp)
        readHttpAndAjpConnector(httpElem, ajp)
        farm.ajp = ajp
      }

      (farmElem \ "server") foreach { serverElem =>
        val server = new Server((serverElem \ "@name").text, toInt((serverElem \ "@shutdownPort").text))
        server.httpPort = toInt((serverElem \ "@httpPort").text)
        server.httpsPort = toInt((serverElem \ "@httpsPort").text)
        server.ajpPort = toInt((serverElem \ "@ajpPort").text)
        farm.servers += server
      }
      conf.farms += farm
    }

    (xml \ "webapp").foreach { webappElem =>
      conf.webapp.docBase = (webappElem \ "@docBase").text
      (webappElem \ "context").foreach { contextElem =>
        val context = new Context((contextElem \ "@path").text)
        context.reloadable = (contextElem \ "@path").text == "true"
        context.runAt = (contextElem \ "@runAt").text
        (contextElem \ "datasource").foreach { dsElem =>
          val ds = new DataSource((dsElem \ "@name").text)
          ds.driver = (dsElem \ "@driver").text
          ds.username = (dsElem \ "@username").text
          ds.url = (dsElem \ "@url").text
          ds.properties ++= (dsElem.attributes.asAttrMap -- Set("name","driver","url","username"))
          context.dataSources += ds
        }
        conf.webapp.contexts += context
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
class TomcatConfig {

  var version = "7.0.50"

  val farms = new collection.mutable.ListBuffer[Farm]

  val webapp = new Webapp

  def farmNames: Set[String] = farms.map(f => f.name).toSet

}