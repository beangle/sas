package org.apache.catalina.loader;

import java.io.File;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.catalina.LifecycleException;

public class RepositoryLoader extends WebappLoader {

  String url;
  String base;

  public RepositoryLoader() {
    this(null);
  }

  public RepositoryLoader(ClassLoader parent) {
    super(parent);
  }

  @Override
  public void startInternal() throws LifecycleException {
    super.startInternal();
    ClassLoader cl = super.getClassLoader();

    if (cl instanceof WebappClassLoader) {
      @SuppressWarnings("resource")
      WebappClassLoader devCl = (WebappClassLoader) cl;
      URL resource = cl.getResource(DependencyResolver.DependenciesFile);
      if (null == resource) { return; }
      File dependency;
      try {
        dependency = File.createTempFile("dependency", ".txt");
        normalizeBase();
        List<Artifact> artifacts = DependencyResolver.resolve(resource, dependency);

        String catalinaHome = System.getenv("TOMCAT_HOME");
        ProcessBuilder pb = new ProcessBuilder(catalinaHome + "/../bin/resolve.sh",
            dependency.getAbsolutePath(), url, base);

        pb.redirectErrorStream(true);
        Process pro = pb.start();
        pro.waitFor();
        log("resolving " + resource.toString());
        StringBuilder sb = new StringBuilder("Append ");
        sb.append(artifacts.size()).append(" jars:");
        Local local = new Local(base);
        for (Artifact artifact : artifacts) {
          File file = new File(local.path(artifact));
          if (!file.exists()) throw new RuntimeException("Cannot find " + artifact);
          sb.append(file.getName());
          sb.append("  ");
          try {
            devCl.addURL(file.toURI().toURL());
          } catch (MalformedURLException e) {
            e.printStackTrace();
          }
        }
        log(sb.toString());
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else {
      logError("Unable to install WebappClassLoader !");
    }
  }

  private void log(String msg) {
    System.out.println((new StringBuilder("[RepositoryLoader]: ")).append(msg).toString());
  }

  private void logError(String msg) {
    System.err.println((new StringBuilder("[RepositoryLoader] Error: ")).append(msg).toString());
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public void setBase(String base) {
    this.base = base;
    normalizeBase();
  }

  private void normalizeBase() {
    if (null == base) {
      this.base = System.getProperty("user.home") + "/.m2/repository";
    } else {
      if (base.endsWith("/")) this.base = base.substring(0, base.length() - 1);
    }
    new File(this.base).mkdirs();
  }

  public static class Artifact {

    public final String groupId;
    public final String artifactId;
    public final String version;
    public final String packaging;

    public Artifact(String gav) {
      String[] infos = gav.split(":");
      this.groupId = infos[0];
      this.artifactId = infos[1];
      this.version = infos[2];
      this.packaging = (infos.length > 3) ? infos[3] : "jar";
    }

    public Artifact(String groupId, String artifactId, String version, String packaging) {
      super();
      this.groupId = groupId;
      this.artifactId = artifactId;
      this.version = version;
      this.packaging = packaging;
    }

    @Override
    public String toString() {
      return this.groupId + ":" + this.artifactId + ":" + this.version + "." + this.packaging;
    }
  }

  static class DependencyResolver {
    public static final String DependenciesFile = "META-INF/beangle/container.dependencies";

    public static List<Artifact> resolve(URL resource, File file) {
      List<Artifact> artifacts = new ArrayList<Artifact>();
      if (null == resource) return Collections.emptyList();
      try {
        InputStreamReader reader = new InputStreamReader(resource.openStream());
        LineNumberReader lr = new LineNumberReader(reader);
        FileWriter writer = new FileWriter(file);
        String line = null;
        do {
          line = lr.readLine();
          if (line != null && !line.isEmpty()) {
            artifacts.add(new Artifact(line));
            writer.write(line);
            writer.write("\n");
          }
        } while (line != null);

        lr.close();
        writer.close();
      } catch (Exception e) {
        e.printStackTrace();
      }

      return artifacts;
    }
  }

  public static class Local {

    public final String base;

    public Local(String base) {
      this.base = base;
    }

    public String path(Artifact artifact) {
      return base + "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/"
          + artifact.version + "/" + artifact.artifactId + "-" + artifact.version + "." + artifact.packaging;
    }
  }
}
