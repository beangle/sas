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

package org.beangle.sas.engine.tomcat;

import jakarta.servlet.ServletContainerInitializer;
import org.apache.catalina.*;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.core.*;
import org.apache.catalina.loader.WebappLoader;
import org.apache.catalina.startup.Constants;
import org.apache.catalina.startup.ContextConfig;
import org.apache.catalina.startup.Tomcat;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;
import org.apache.tomcat.util.scan.StandardJarScanner;
import org.beangle.sas.engine.Server;

import java.io.File;
import java.util.Iterator;
import java.util.ServiceLoader;

public class TomcatServerBuilder {
  private final Server.Config config;
  private static final Log log = LogFactory.getLog(TomcatServerBuilder.class);
  public TomcatServerBuilder(Server.Config config) {
    this.config = config;
  }

  public Tomcat build() {
    Tomcat tomcat = new Tomcat();
    File baseDir = config.createTempDir("tomcat");
    log.info("Create temp base dir: " + baseDir.getAbsolutePath());
    new File(baseDir, "webapps").mkdirs();
    tomcat.setBaseDir(baseDir.getAbsolutePath());
    //tomcat is startup class
    //server{service{engine{host{context}}}}
    configServer((StandardServer) tomcat.getServer());
    configConnector(tomcat);
    configEngine(tomcat.getEngine());
    configHost((StandardHost) tomcat.getHost());
    prepareContext(tomcat.getHost());
    return tomcat;
  }

  protected void configServer(StandardServer server) {
    if (!config.devMode) {
      AprLifecycleListener apr = new AprLifecycleListener();
      apr.setSSLEngine("on");
      server.addLifecycleListener(apr);
      server.addLifecycleListener(new JreMemoryLeakPreventionListener());
      server.addLifecycleListener(new ThreadLocalLeakPreventionListener());
    }
  }

  protected void configConnector(Tomcat tomcat) {
    Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
    connector.setThrowOnFailure(true);
    connector.setPort(config.port);
    connector.setURIEncoding("UTF-8");
    connector.setXpoweredBy(false);
    connector.setProperty("bindOnInit", "false");
    tomcat.getService().addConnector(connector);
    tomcat.setConnector(connector);
  }

  protected void configEngine(Engine engine) {
    //engine.addLifecycleListener(new GlobalResourcesLifecycleListener());
    engine.setBackgroundProcessorDelay(0);
  }

  protected void configHost(StandardHost host) {
    host.setAutoDeploy(false);
    host.setErrorReportValveClass("org.beangle.sas.engine.tomcat.SwallowErrorValve");
  }

  protected void prepareContext(Host host) {
    StandardContext context = new StandardContext();
    context.setName(config.contextPath);
    context.setPath(config.contextPath);
    //embeded or as server
    WebappLoader loader = new WebappLoader();
    if (config.docBase == null) {
      loader.setLoaderClass(EmbeddedWebappClassLoader.class.getName());
      loader.setDelegate(true);
      context.addLifecycleListener(new FixContextListener());
      context.setDocBase(config.createTempDir("tomcat-docbase").getAbsolutePath());
      addInitializer(context);
    } else {
      loader.setLoaderClass(DependencyClassLoader.class.getName());
      loader.setDelegate(false);
      context.addLifecycleListener(new ContextConfig());
      context.setDocBase(config.docBase);
    }
    context.setLoader(loader);
    // disable scanning
    skipScanning(context);

    // container sci support
    if (!config.jspSupport && !config.websocketSupport) {
      context.setContainerSciFilter("apache");
    } else if (!config.jspSupport) {
      context.setContainerSciFilter("JasperInitializer");
    } else if (!config.websocketSupport) {
      context.setContainerSciFilter("WsSci");
    }

    // default servlet and jsp
    addDefaultServlet(context);

    if (config.devMode) {
      context.setReloadable(true);
    }
    if (config.unpack.equals("true")) {
      context.setUnpackWAR(true);
    } else if (config.unpack.equals("false")) {
      context.setUnpackWAR(false);
    }
    context.setDefaultWebXml(Constants.NoDefaultWebXml);
    host.addChild(context);
  }

  private void skipScanning(StandardContext context) {
    StandardJarScanner scanner = new StandardJarScanner();
    scanner.setScanAllDirectories(false);
    scanner.setScanAllFiles(false);
    scanner.setScanClassPath(false);
    scanner.setScanManifest(false);
    scanner.setScanBootstrapClassPath(false);
    context.setJarScanner(scanner);
    context.setIgnoreAnnotations(true);
  }

  private void addInitializer(StandardContext context) {
    try {
      ServiceLoader<ServletContainerInitializer> loader = ServiceLoader.load(ServletContainerInitializer.class);
      Iterator<ServletContainerInitializer> iter = loader.iterator();
      while (iter.hasNext()) {
        context.addServletContainerInitializer(iter.next(), null);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void addDefaultServlet(Context ctx) {
    // Default servlet
    Wrapper dft = Tomcat.addServlet(ctx, "default", "org.apache.catalina.servlets.DefaultServlet");
    dft.setLoadOnStartup(1);
    dft.setOverridable(true);
    dft.addInitParameter("debug", "0");
    dft.addInitParameter("listings", "false");
    ctx.addServletMappingDecoded("/", "default");

    if (config.jspSupport) {
      // JSP servlet (by class name - to avoid loading all deps)
      Wrapper jsp = Tomcat.addServlet(ctx, "jsp", "org.apache.jasper.servlet.JspServlet");
      jsp.addInitParameter("fork", "false");
      jsp.addInitParameter("development", "false");
      jsp.setLoadOnStartup(3);
      jsp.setOverridable(true);
      ctx.addServletMappingDecoded("*.jsp", "jsp");
      ctx.addServletMappingDecoded("*.jspx", "jsp");
    }
    // Sessions(minutes)
    ctx.setSessionTimeout(30);

    // MIME type mappings
    Tomcat.addDefaultMimeTypeMappings(ctx);

    // Welcome files
    ctx.addWelcomeFile("index.html");
    ctx.addWelcomeFile("index.htm");
    if (config.jspSupport) ctx.addWelcomeFile("index.jsp");
  }

  static class FixContextListener implements LifecycleListener {
    @Override
    public void lifecycleEvent(LifecycleEvent event) {
      try {
        Context context = (Context) event.getLifecycle();
        if (event.getType().equals(Lifecycle.CONFIGURE_START_EVENT)) {
          context.setConfigured(true);
        }
      } catch (ClassCastException e) {
      }
    }
  }
}
