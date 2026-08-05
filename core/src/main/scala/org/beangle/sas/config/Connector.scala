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

/**
 * Sas Connector
 */
sealed class Connector {

  /**
   * Sets the protocol to handle incoming traffic
   */
  var protocol: String = _

  /**
   * This specifies the character encoding used to decode the URI bytes, after %xx decoding the URL.
   *  If not specified, UTF-8(not ISO-8859-1) will be used.
   */
  var URIEncoding: String = "UTF-8"

  /**
   * Set to true if you want calls to request.getRemoteHost() to perform DNS lookups
   * in order to return the actual host name of the remote client.
   * Set to false to skip the DNS lookup and return the IP address in String form instead (thereby improving performance).
   * By default, DNS lookups are disabled.
   */
  var enableLookups: Boolean = false
  /**
   * If this Connector is supporting non-SSL requests,
   * and a request is received for which a matching <security-constraint> requires SSL transport,
   * Catalina will automatically redirect the request to the port number specified here.
   */
  /**
   * The maximum queue length for incoming connection requests when all possible request processing threads are in use.
   * Any requests received when the queue is full will be refused. The default value is 100
   */
  var acceptCount: Option[Int] = None

  /**
   * The maximum number of connections that the server will accept and process at any given time.
   * When this number has been reached, the server will not accept any more connections until the number of connections falls below this value.
   * The operating system may still accept connections based on the acceptCount setting.
   *
   * Default value varies by connector type.
   *
   * For NIO the default is 10000. For APR/native, the default is 8192.
   */
  var maxConnections: Option[Int] = None
}

class HttpConnector extends Connector {

  this.protocol = "HTTP/1.1"

  /**
   * 20s
   */
  var connectionTimeout: Int = 20000

  /**
   * This flag allows the servlet container to use a different,
   * usually longer connection timeout during data upload.
   * If not specified, this attribute is set to true which disables this longer timeout.
   */
  var disableUploadTimeout: Boolean = true
}
