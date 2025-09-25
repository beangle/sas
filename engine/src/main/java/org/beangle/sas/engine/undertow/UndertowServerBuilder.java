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
import io.undertow.UndertowOptions;
import io.undertow.server.HttpHandler;
import io.undertow.servlet.Servlets;
import io.undertow.servlet.api.DeploymentInfo;
import io.undertow.servlet.api.ServletContainer;
import io.undertow.servlet.api.ServletContainerInitializerInfo;
import io.undertow.servlet.api.ServletStackTraces;
import io.undertow.servlet.handlers.DefaultServlet;
import jakarta.servlet.ServletContainerInitializer;
import jakarta.servlet.ServletException;
import org.beangle.sas.engine.Server;

import java.io.File;
import java.util.Collections;

public class UndertowServerBuilder {
  private final Server.Config config;

  public UndertowServerBuilder(Server.Config config) {
    this.config = config;
  }

  public Undertow build(String baseDir) throws ServletException {
    Undertow.Builder builder = Undertow.builder();

    Integer bufferSize = config.getInt("buffer-size");
    if (null != bufferSize) builder.setBufferSize(bufferSize);

    Integer ioThread = config.getInt("io-thread");
    if (null != ioThread) builder.setIoThreads(ioThread);

    Integer workerThreads = config.getInt("worker-threads");
    if (null != workerThreads) builder.setWorkerThreads(workerThreads);

    Integer directBuffers = config.getInt("direct-buffers");
    if (null != directBuffers) builder.setBufferSize(directBuffers);

    builder.addHttpListener(config.port, config.hostname);
    builder.setServerOption(UndertowOptions.SHUTDOWN_TIMEOUT, 0);
//    builder.setServerOption(UndertowOptions.ENABLE_HTTP2, http2.isEnabled());
    ServletContainer sc = Servlets.newContainer();
    builder.setHandler(createDeployments(sc, baseDir));
    return builder.build();
  }

  private ClassLoader getServletClassLoader() {
    return getClass().getClassLoader();
  }

  private void addInitializers(DeploymentInfo deployment) {
    var classLoader = getServletClassLoader();
    try {
      var urls = classLoader.getResources("META-INF/services/jakarta.servlet.ServletContainerInitializer");
      while (urls.hasMoreElements()) {
        var url = urls.nextElement();
        var is = url.openStream();
        var serviceName = new String(is.readAllBytes()).trim();
        is.close();
        //不是竞品的初始化服务
        if (!serviceName.startsWith("org.apache.tomcat.") && !serviceName.startsWith("org.eclipse.jetty.")) {
          var clazz = (Class<? extends ServletContainerInitializer>) classLoader.loadClass(serviceName);
          deployment.addServletContainerInitializer(new ServletContainerInitializerInfo(clazz, Collections.emptySet()));
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private HttpHandler createDeployments(ServletContainer sc, String baseDir) throws ServletException {
    DeploymentInfo di = Servlets.deployment();
    addInitializers(di);

    di.setUrlEncoding("UTF-8");
    di.setDefaultEncoding("UTF-8");
    di.setDefaultRequestEncoding("UTF-8");
    di.setClassLoader(getServletClassLoader());
    di.setContextPath(config.contextPath);
    //di.setResourceManager(new DefaultResourceLoader());
    di.setDeploymentName(config.contextPath.replace('/', '_'));
    if (config.defaultServletSupport) {
      di.addServlet(Servlets.servlet("default", DefaultServlet.class));
    }
    di.setServletStackTraces(ServletStackTraces.NONE);
    di.setEagerFilterInit(true);
    di.setTempDir(new File(baseDir + File.separator + "temp"));

    //ignore mimetype registration
    var manager = sc.addDeployment(di);
    manager.deploy();
    var sm = manager.getDeployment().getSessionManager();
    sm.setDefaultSessionTimeout(config.defaultSessionTimeout);

    var h = manager.start();
    Handlers.path().addPrefixPath(config.contextPath, h);
    return h;
  }

}
