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
package org.beangle.sas.undertow

import java.io.Closeable
import java.util.logging.Logger

import io.undertow.server.HttpHandler
import io.undertow.servlet.Servlets
import io.undertow.servlet.api.{ServletContainer, ServletStackTraces}
import io.undertow.{Handlers, Undertow}
import org.beangle.sas.model.Container

class Server(name: String, ips: Set[String], container: Container) extends org.beangle.sas.Server {

  val logger: Logger = Logger.getLogger(classOf[Server].toString)

  val monitor = new Object

  var closeable: Option[Closeable] = None

  var undertow: Undertow = _

  var started = false

  override def start(): Unit = {
    this.monitor synchronized {
      if (this.started) {
        return
      }
      try {
        if (this.undertow == null) {
          this.undertow = createUndertowServer()
        }
        this.undertow.start()
        this.started = true
        logger.info("Undertow started.")
      }
      catch {
        case ex: Exception =>
          throw new RuntimeException("Unable to start embedded Undertow", ex)
      }
      finally {
        stopSilently()
      }
    }
  }

  private def stopSilently(): Unit = {
    if (this.undertow != null) {
      this.undertow.stop()
      closeable foreach { c => c.close() }
    }
  }

  override def stop(): Unit = {
    this.monitor synchronized {
      if (!this.started) return
      this.started = false
      try {
        this.undertow.stop()
        closeable foreach { c => c.close() }
      } catch {
        case ex: Exception => throw new RuntimeException("Unable to stop undertow", ex)
      }
    }
  }

  private def createUndertowServer(): Undertow = {
    val builder = Undertow.builder()

    //    if (this.bufferSize != null) {
    //      builder.setBufferSize(this.bufferSize);
    //    }
    //    if (this.ioThreads != null) {
    //      builder.setIoThreads(this.ioThreads);
    //    }
    //    if (this.workerThreads != null) {
    //      builder.setWorkerThreads(this.workerThreads);
    //    }
    //    if (this.directBuffers != null) {
    //      builder.setDirectBuffers(this.directBuffers);
    //    }
    //    for (UndertowBuilderCustomizer customizer : this.builderCustomizers) {
    //      customizer.customize(builder);
    //    }
    container.getServer(name) foreach { s =>
      ips foreach { ip =>
        if (s.farm.hosts.exists(_.ip == ip)) {
          builder.addHttpListener(s.http, ip)
        }
      }
    }
    val sc = Servlets.newContainer()
    builder.setHandler(createDeployments(sc))
    builder.build()
  }

  private def createDeployments(sc: ServletContainer): HttpHandler = {
    var httpHandler: HttpHandler = null
    val server = container.getServer(name).orNull
    container.getDeployments(server,ips) foreach { deploy =>
      val deployment = Servlets.deployment()
      //deployment.setClassLoader(getServletClassLoader());
      deployment.setContextPath(deploy.path)
      //    deployment.setDisplayName(getDisplayName())
      deployment.setDeploymentName(name + "_" + deploy.path.replace('/', '_'))
      deployment.setServletStackTraces(ServletStackTraces.NONE)
      //    deployment.setResourceManager(getDocumentRootResourceManager());
      deployment.setEagerFilterInit(true)
      //      val dir = getValidSessionStoreDir()
      //      deployment.setSessionPersistenceManager(new FileSessionPersistence(dir));
      val manager = sc.addDeployment(deployment)
      manager.deploy()
      val h = manager.start()
      if (null == httpHandler) {
        httpHandler = h
      }
      httpHandler = Handlers.path().addPrefixPath(deploy.path, httpHandler)
    }
    //    val sessionManager = manager.getDeployment("beangle-sas").getSessionManager();
    //    val timeoutDuration = getSession().getTimeout();
    //    int sessionTimeout = (isZeroOrLess(timeoutDuration) ? -1
    //      : (int) timeoutDuration.getSeconds());
    //    sessionManager.setDefaultSessionTimeout(sessionTimeout);
    httpHandler
  }

}
