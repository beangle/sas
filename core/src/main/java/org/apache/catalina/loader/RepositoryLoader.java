package org.apache.catalina.loader;

import java.io.File;
import java.net.MalformedURLException;

import org.apache.catalina.LifecycleException;
import org.beangle.maven.launcher.Artifact;
import org.beangle.maven.launcher.ArtifactDownloader;
import org.beangle.maven.launcher.CustomDependencyResolver;
import org.beangle.maven.launcher.LocalRepository;
import org.beangle.maven.launcher.RemoteRepository;

public class RepositoryLoader extends WebappLoader {

  CustomDependencyResolver resolver = new CustomDependencyResolver();
  String url;
  String cacheLayout = "maven2";
  String cacheBase;
  RemoteRepository remote;
  LocalRepository local;

  public RepositoryLoader() {
    this(null);
  }

  public RepositoryLoader(ClassLoader parent) {
    super(parent);
  }

  @Override
  public void startInternal() throws LifecycleException{
    log("Loading jars from:" + cacheBase);
    remote = (null == url) ? new RemoteRepository() : new RemoteRepository(url);
    local = new LocalRepository(cacheBase, cacheLayout);

    super.startInternal();
    ClassLoader cl = super.getClassLoader();
    if (cl instanceof WebappClassLoader) {
      @SuppressWarnings("resource")
      WebappClassLoader devCl = (WebappClassLoader) cl;
      StringBuilder sb = new StringBuilder("Add Class Path:");
      Artifact[] artifacts = resolver.resolve(cl.getResource(CustomDependencyResolver.DependenciesFile));
      new ArtifactDownloader(remote, local).download(artifacts);
      for (Artifact artifact : artifacts) {
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
}
