package org.apache.catalina.loader;

import java.io.File;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.catalina.LifecycleException;
import org.apache.catalina.loader.maven.ArtifactDownloader;
import org.apache.catalina.loader.maven.Repository;

public class RepositoryLoader extends WebappLoader {

  DependencyResolver resolver = new DependencyResolver();
  String url;
  String cacheLayout = "maven2";
  String cacheBase;
  Repository.Remote remote;
  Repository.Local local;

  public RepositoryLoader() {
    this(null);
  }

  public RepositoryLoader(ClassLoader parent) {
    super(parent);
  }

  @Override
  public void startInternal() throws LifecycleException {
    remote = (null == url) ? new Repository.Remote() : new Repository.Remote(url);
    local = new Repository.Local(cacheLayout, cacheBase);
    log("Loading jars from:" + local.base);

    super.startInternal();
    ClassLoader cl = super.getClassLoader();
    if (cl instanceof WebappClassLoader) {
      @SuppressWarnings("resource")
      WebappClassLoader devCl = (WebappClassLoader) cl;
      StringBuilder sb = new StringBuilder("Add Class Path:");
      URL resource = cl.getResource(DependencyResolver.DependenciesFile);
      if (null == resource) {
        log("Cannot find " + DependencyResolver.DependenciesFile + ",Repository loading aborted.");
        return;
      }
      Repository.Artifact[] artifacts = resolver.resolve(resource);
      new ArtifactDownloader(remote, local).download(artifacts);
      for (Repository.Artifact artifact : artifacts) {
        File file = new File(local.path(artifact));
        sb.append(file.getName());
        sb.append("  ");
        try {
          devCl.addURL(file.toURI().toURL());
        } catch (MalformedURLException e) {
          e.printStackTrace();
        }
      }
      log(sb.toString());
    } else {
      logError("Unable to install WebappClassLoader !");
    }
  }

  private void log(String msg) {
    System.out.println((new StringBuilder("[RepositoryLoader] ")).append(msg).toString());
  }

  private void logError(String msg) {
    System.err.println((new StringBuilder("[RepositoryLoader] Error: ")).append(msg).toString());
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public void setCacheLayout(String cacheLayout) {
    this.cacheLayout = cacheLayout;
  }

  public void setCacheBase(String cacheBase) {
    this.cacheBase = cacheBase;
  }

  class DependencyResolver {
    public static final String DependenciesFile = "META-INF/beangle/container.dependencies";

    public Repository.Artifact[] resolve(URL resource) {
      List<Repository.Artifact> artifacts = new ArrayList<Repository.Artifact>();
      if (null == resource) return new Repository.Artifact[0];
      try {
        InputStreamReader reader = new InputStreamReader(resource.openStream());
        LineNumberReader lr = new LineNumberReader(reader);
        String line = null;
        do {
          line = lr.readLine();
          if (line != null && !line.isEmpty()) {
            String[] infos = line.split(":");
            artifacts.add(new Repository.Artifact(infos[0], infos[1], infos[2]));
          }
        } while (line != null);

        lr.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return artifacts.toArray(new Repository.Artifact[0]);
    }
  }

}
