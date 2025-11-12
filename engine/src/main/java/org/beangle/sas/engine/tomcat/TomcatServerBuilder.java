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
import org.apache.tomcat.util.compat.JreCompat;
import org.apache.tomcat.util.scan.StandardJarScanner;
import org.beangle.sas.engine.Server;

import java.io.File;
import java.util.ArrayList;
import java.util.ServiceLoader;
import java.util.regex.Pattern;

public class TomcatServerBuilder {
  private final Server.Config config;
  private static final Log log = LogFactory.getLog(TomcatServerBuilder.class);

  public TomcatServerBuilder(Server.Config config) {
    this.config = config;
  }

  public Tomcat build(String baseDir) {
    Tomcat tomcat = new Tomcat();
    tomcat.setBaseDir(baseDir);
    //tomcat is startup class
    //server{service{engine{host{context}}}}
    configServer((StandardServer) tomcat.getServer());
    configConnector(tomcat);
    configEngine(tomcat.getEngine());
    configHost((StandardHost) tomcat.getHost());
    prepareContext(tomcat, tomcat.getHost());
    return tomcat;
  }

  protected void configServer(StandardServer server) {
    if (!config.devMode) {
      server.addLifecycleListener(new JreMemoryLeakPreventionListener());
      server.addLifecycleListener(new ThreadLocalLeakPreventionListener());
    }
  }

  protected void configConnector(Tomcat tomcat) {
    Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
    connector.setThrowOnFailure(true);
    connector.setPort(config.port);
    connector.setURIEncoding("UTF-8"); //设置编码
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
    host.setDeployOnStartup(false);
    if (!config.devMode) {
      host.setErrorReportValveClass("org.beangle.sas.engine.tomcat.SwallowErrorValve");
    }
  }

  protected void prepareContext(Tomcat tomcat, Host host) {
    StandardContext context = new StandardContext();
    context.setName(config.contextPath);
    context.setPath(config.contextPath);
    skipScanning(context); // disable scanning
    String sciFilter = null;
    // container sci support,which one should be filtered and ignored
    if (!config.jspSupport) {
      sciFilter = "JasperInitializer";
    }
    Pattern sciFilterPattern = null;
    if (null != sciFilter) {
      context.setContainerSciFilter(sciFilter);
      sciFilterPattern = Pattern.compile(sciFilter);
    }

    var parentClassLoader = Thread.currentThread().getContextClassLoader();
    context.setParentClassLoader(parentClassLoader);

    WebappLoader loader = new WebappLoader();
    //under graalvm or jvm
    if (JreCompat.isGraalAvailable()) {
      System.setProperty("org.apache.tomcat.util.modeler.disable", "true");
      context.setDocBase("classpath:webapp");
      loader.setLoaderInstance(new EmbeddedClassLoader(parentClassLoader));
      loader.setDelegate(true);
      context.addLifecycleListener(new FixContextListener());
      addInitializers(context, sciFilterPattern);
      context.setResourceOnlyServlets("default");
      disableTomcatSSL();
    } else {
      //embedded(开发环境) or as server(生产环境)
      if (config.docBase == null) {//run in IDE
        //禁用监控
        System.setProperty("org.apache.tomcat.util.modeler.disable", "true");
        disableTomcatSSL();
        String targetClassPath = parentClassLoader.getResource("").getFile();
        int targetIdx = targetClassPath.indexOf("/target/");
        if (targetIdx > 0) {
          String projectWebapp = targetClassPath.substring(0, targetIdx) + "/src/main/webapp";
          if (new File(projectWebapp).exists()) {
            context.setDocBase(projectWebapp);
          }
        }
        if (null == context.getDocBase()) {
          context.setDocBase(config.createTempDir("tomcat-docbase").getAbsolutePath());
        }
        loader.setLoaderInstance(new EmbeddedClassLoader(parentClassLoader));
        loader.setDelegate(true);
        context.addLifecycleListener(new FixContextListener());
        context.setUseNaming(false);//禁用JNDI

        addInitializers(context, sciFilterPattern);
      } else {//run as server
        context.setDocBase(config.docBase);
        loader.setLoaderClass(DependencyClassLoader.class.getName());
        loader.setDelegate(false);
        context.addLifecycleListener(new ContextConfig());
      }
    }
    context.setLoader(loader);

    // default servlet and jsp
    addDefaults(context);

    if (config.devMode) context.setReloadable(true);
    if (config.unpack.equals("true")) {
      context.setUnpackWAR(true);
    } else if (config.unpack.equals("false")) {
      context.setUnpackWAR(false);
    }
    context.setDefaultWebXml(Constants.NoDefaultWebXml);
    host.addChild(context);
  }

  private static void disableTomcatSSL() {
    // 禁用 OpenSSL 检测（Tomcat 不会尝试加载 libtcnative-1.dll 等 OpenSSL 库）
    System.setProperty("org.apache.tomcat.util.net.openssl.OpenSSL.disable", "true");
    // 禁用 JSSE SSL 实现（若无需 JSSE 提供的 SSL 功能）
    System.setProperty("org.apache.tomcat.util.net.jsse.JSSESocketFactory.disable", "true");
    // 禁用 SSL 主机配置自动初始化
    System.setProperty("org.apache.catalina.connector.Connector.SSL_HOST_CONFIG_DISABLED", "true");
    // 禁用 Tomcat 对 SSL 协议的检测
    System.setProperty("org.apache.tomcat.util.net.SSLProtocol.disable", "true");
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

  private void addInitializers(StandardContext context, Pattern filter) {
    try {
      ServiceLoader<ServletContainerInitializer> loader = ServiceLoader.load(ServletContainerInitializer.class);
      var services = new ArrayList<ServletContainerInitializer>();
      var iter = loader.iterator();
      while (iter.hasNext()) {
        var s = iter.next();
        var clazzName = s.getClass().getName();
        if (null == filter || !filter.matcher(clazzName).find()) {
          services.add(s);
        }
      }
      for (var s : services) {
        context.addServletContainerInitializer(s, null);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void addDefaults(Context ctx) {
    // Default servlet
    if (config.defaultServletSupport) {
      Wrapper dft = Tomcat.addServlet(ctx, "default", "org.apache.catalina.servlets.DefaultServlet");
      dft.setLoadOnStartup(1);
      dft.setOverridable(true);
      dft.addInitParameter("debug", "0");
      dft.addInitParameter("listings", "false");
      ctx.addServletMappingDecoded("/", "default");
    }

    // JSP servlet (by class name - to avoid loading all deps)
    if (config.jspSupport) {
      Wrapper jsp = Tomcat.addServlet(ctx, "jsp", "org.apache.jasper.servlet.JspServlet");
      jsp.addInitParameter("fork", "false");
      jsp.addInitParameter("development", "false");
      jsp.setLoadOnStartup(3);
      jsp.setOverridable(true);
      ctx.addServletMappingDecoded("*.jsp", "jsp");
      ctx.addServletMappingDecoded("*.jspx", "jsp");
    }
    // Sessions(minutes)
    ctx.setSessionTimeout(config.defaultSessionTimeout);

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
        if (event.getType().equals(Lifecycle.CONFIGURE_START_EVENT)) context.setConfigured(true);
      } catch (ClassCastException e) {
      }
    }
  }
}
