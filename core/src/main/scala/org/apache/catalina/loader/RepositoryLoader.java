package org.apache.catalina.loader;

import java.io.File;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.catalina.LifecycleException;
import org.beangle.as.maven.ArtifactDownloader;
import org.beangle.as.maven.Repository;

public class RepositoryLoader extends WebappLoader {

  DependencyResolver resolver = new DependencyResolver();
  String url;
  String base;
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
    local = new Repository.Local(base);
    log("Loading jars from:" + local.base);
    super.startInternal();
    ClassLoader cl = super.getClassLoader();
    if (cl instanceof WebappClassLoader) {
      @SuppressWarnings("resource")
      WebappClassLoader devCl = (WebappClassLoader) cl;
      URL resource = cl.getResource(DependencyResolver.DependenciesFile);
      if (null == resource) {
        log("Cannot find " + DependencyResolver.DependenciesFile + ",Repository loading aborted.");
        return;
      }
      List<Repository.Artifact> artifacts = resolver.resolve(resource);
      StringBuilder sb = new StringBuilder("Append ");
      sb.append(artifacts.size()).append(" jars:");
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

  public void setBase(String base) {
    this.base = base;
  }

  class DependencyResolver {
    public static final String DependenciesFile = "META-INF/beangle/container.dependencies";

    public List<Repository.Artifact> resolve(URL resource) {
      List<Repository.Artifact> artifacts = new ArrayList<Repository.Artifact>();
      if (null == resource) return Collections.emptyList();
      try {
        InputStreamReader reader = new InputStreamReader(resource.openStream());
        LineNumberReader lr = new LineNumberReader(reader);
        String line = null;
        do {
          line = lr.readLine();
          if (line != null && !line.isEmpty()) {
            artifacts.add(new Repository.Artifact(line));
          }
        } while (line != null);

        lr.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return artifacts;
    }
  }

}
