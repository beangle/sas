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
package org.beangle.tomcat.configer.model

import java.{ util => ju }
/**
 * Tomcat connector
 * @see http://tomcat.apache.org/tomcat-7.0-doc/config/index.html
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
   * If this Connector is supporting non-SSL requests,
   * and a request is received for which a matching <security-constraint> requires SSL transport,
   * Catalina will automatically redirect the request to the port number specified here.
   */
  var redirectPort: Option[Int] = _

  /**
   * Set to true if you want calls to request.getRemoteHost() to perform DNS lookups
   * in order to return the actual host name of the remote client.
   * Set to false to skip the DNS lookup and return the IP address in String form instead (thereby improving performance).
   * By default, DNS lookups are disabled.
   */
  var enableLookups: Boolean = false
}

trait HttpAndAjp {
  /**
   * The maximum queue length for incoming connection requests when all possible request processing threads are in use.
   * Any requests received when the queue is full will be refused. The default value is 100
   */
  var acceptCount: Int = 100

  /**
   * The maximum number of request processing threads to be created by this Connector,
   * which therefore determines the maximum number of simultaneous requests that can be handled.
   * If not specified, this attribute is set to 200. If an executor is associated with this connector,
   * this attribute is ignored as the connector will execute tasks using the executor rather than an internal thread pool.
   */
  var maxThreads: Int = 200

  /**
   * The maximum number of connections that the server will accept and process at any given time.
   * When this number has been reached, the server will not accept any more connections until the number of connections falls below this value.
   * The operating system may still accept connections based on the acceptCount setting.
   *
   * Default value varies by connector type.
   *
   * For BIO the default is the value of maxThreads unless an Executor is used
   * in which case the default will be the value of maxThreads from the executor. For NIO the default is 10000.
   * For APR/native, the default is 8192.
   */
  var maxConnections: Option[Int] = _

  /**
   * The minimum number of threads always kept running. If not specified, the default of 10 is used.
   */
  var minSpareThreads: Int = 10
}

class HttpConnector extends Connector with HttpAndAjp {

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

  /**
   * The Connector may use HTTP/1.1 GZIP compression in an attempt to save server bandwidth.
   *  The acceptable values for the parameter is
   *  "off" (disable compression),
   *  "on" (allow compression, which causes text data to be compressed),
   *  "force" (forces compression in all cases),
   *  or a numerical integer value (which is equivalent to "on",
   *   but specifies the minimum amount of data before the output is compressed).
   *  If the content-length is not known and compression is set to "on" or more aggressive,
   *  the output will also be compressed.
   *  If not specified, this attribute is set to "off".
   */
  var compression: String = "off"

  /**
   * If compression is set to "on" then
   * this attribute may be used to specify the minimum amount of data before the output is compressed.
   * If not specified, this attribute is defaults to "2048"(2k).
   */
  var compressionMinSize: Int = 2048

  /**
   * The value is a comma separated list of MIME types for which HTTP compression may be used.
   * The default value is text/html,text/xml,text/javascript,text/css,text/plain.
   */
  var compressionMimeType: String = "text/html,text/xml,text/javascript,text/css,text/plain"
}

class AjpConnector extends Connector with HttpAndAjp {
  this.protocol = "AJP/1.3"

}

class HttpsConnector extends Connector with HttpAndAjp {
  this.protocol = "org.apache.coyote.http11.Http11NioProtocol"
  val properties = new ju.Properties
}

