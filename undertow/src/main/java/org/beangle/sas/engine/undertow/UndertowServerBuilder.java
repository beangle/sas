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

package org.beangle.sas.engine.undertow;

import io.undertow.Handlers;
import io.undertow.Undertow;
import io.undertow.server.HttpHandler;
import io.undertow.servlet.Servlets;
import io.undertow.servlet.api.DeploymentInfo;
import io.undertow.servlet.api.DeploymentManager;
import io.undertow.servlet.api.ServletContainer;
import io.undertow.servlet.api.ServletStackTraces;
import jakarta.servlet.ServletException;
import org.beangle.sas.engine.Server;

public class UndertowServerBuilder {
  private final Server.Config config;

  public UndertowServerBuilder(Server.Config config) {
    this.config = config;
  }

  public Undertow builder() throws ServletException {
    Undertow.Builder builder = Undertow.builder();
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
    builder.addHttpListener(config.port, config.hostname);
    ServletContainer sc = Servlets.newContainer();
    builder.setHandler(createDeployments(sc));
    return builder.build();
  }

  private HttpHandler createDeployments(ServletContainer sc) throws ServletException {
    DeploymentInfo deployment = Servlets.deployment();
    deployment.setUrlEncoding("UTF-8");
    //deployment.setClassLoader(getServletClassLoader());
    deployment.setContextPath(config.contextPath);
    //    deployment.setDisplayName(getDisplayName())
    deployment.setDeploymentName(config.contextPath.replace('/', '_'));
    deployment.setServletStackTraces(ServletStackTraces.NONE);
    //    deployment.setResourceManager(getDocumentRootResourceManager());
    deployment.setEagerFilterInit(true);
    //      val dir = getValidSessionStoreDir()
    //      deployment.setSessionPersistenceManager(new FileSessionPersistence(dir));
    DeploymentManager manager = sc.addDeployment(deployment);
    manager.deploy();
    HttpHandler h = manager.start();
    Handlers.path().addPrefixPath(config.contextPath, h);
    //    val sessionManager = manager.getDeployment("beangle-sas").getSessionManager();
    //    val timeoutDuration = getSession().getTimeout();
    //    int sessionTimeout = (isZeroOrLess(timeoutDuration) ? -1
    //      : (int) timeoutDuration.getSeconds());
    //    sessionManager.setDefaultSessionTimeout(sessionTimeout);
    return h;
  }

}
