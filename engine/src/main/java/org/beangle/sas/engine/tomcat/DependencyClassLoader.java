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

import org.apache.catalina.LifecycleException;
import org.apache.catalina.loader.ParallelWebappClassLoader;
import org.apache.catalina.loader.WebappClassLoaderBase;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;
import org.beangle.sas.engine.Dependency;

import java.io.File;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class DependencyClassLoader extends ParallelWebappClassLoader {

  private static final Log log = LogFactory.getLog(DependencyClassLoader.class);
  private String base;

  private boolean enableNotFoundClassResourceCache = false;

  public DependencyClassLoader(ClassLoader parent) {
    super(parent);
  }

  @Override
  public void start() throws LifecycleException {
    super.start();
    if ("true".equals(System.getProperty("sas.disableDependencyLoader"))) {
      return;
    }
    var ctx = this.resources.getContext();
    var libs = ctx.findParameter(ExtendableWebappLoader.ExtendedLibsName);
    ctx.removeParameter(ExtendableWebappLoader.ExtendedLibsName);

    URL resource = getResource(Dependency.OldDependenciesFile);
    if (null == resource) {
      resource = getResource(Dependency.DependenciesFile);
      if (null == resource) return;
    }
    normalizeBase();

    //合并启动参数和war中的依赖
    List<Dependency.Artifact> prefixes = Dependency.Resolver.parse(libs);
    List<Dependency.Artifact> dependencyJars = Dependency.Resolver.resolve(resource);
    List<Dependency.Artifact> artifacts = Dependency.Resolver.merge(prefixes, dependencyJars);

    Dependency.LocalRepo local = new Dependency.LocalRepo(base);
    List<Dependency.Artifact> missings = new ArrayList<Dependency.Artifact>();
    List<Dependency.Artifact> added = new ArrayList<Dependency.Artifact>();
    for (Dependency.Artifact artifact : artifacts) {
      File file = new File(local.path(artifact));
      if (!file.exists()) {
        missings.add(artifact);
        continue;
      }
      //ignore container artifacts
      if (artifact.groupId.equals("jakarta.servlet")) continue;
      if (artifact.groupId.equals("jakarta.websocket")) continue;
      if (artifact.groupId.equals("org.apache.tomcat")) continue;
      if (artifact.groupId.equals("org.beangle.sas")) continue;
      try {
        this.addURL(file.toURI().toURL());
        added.add(artifact);
      } catch (MalformedURLException e) {
        e.printStackTrace();
      }
    }

    log.info("Append " + added.size() + " jars (listed in " + resource + ")");
    if (!missings.isEmpty()) {
      throw new RuntimeException("Cannot find " + missings);
    }
  }

  public void setBase(String base) {
    this.base = base;
  }

  private void normalizeBase() {
    if (null == base) {
      this.base = System.getProperty("user.home") + "/.m2/repository";
    } else {
      if (base.endsWith("/")) this.base = base.substring(0, base.length() - 1);
    }
    new File(this.base).mkdirs();
  }

  public void setEnableNotFoundClassResourceCache(boolean enableNotFoundClassResourceCache) {
    this.enableNotFoundClassResourceCache = enableNotFoundClassResourceCache;
  }

  /**
   * Override missing cache size,when enabled,It cannot find suitable resources and classes.
   *
   * @param notFoundClassResourceCacheSize
   */
  public void setNotFoundClassResourceCacheSize(int notFoundClassResourceCacheSize) {
    var size = enableNotFoundClassResourceCache ? notFoundClassResourceCacheSize : 0;
    try {
      var lookup = MethodHandles.lookup();
      var h1 = lookup.findSpecial(WebappClassLoaderBase.class, "setNotFoundClassResourceCacheSize", MethodType.methodType(void.class, int.class), getClass());
      h1.invoke(this, size);
      if (notFoundClassResourceCacheSize > 0 && 0 == size) {
        log.info("Disable Tomcat NotFoundClassResourceCache");
      }
    } catch (Throwable e) {
      //ignore ,maybe tomcat 10 or lower
    }
  }
}
