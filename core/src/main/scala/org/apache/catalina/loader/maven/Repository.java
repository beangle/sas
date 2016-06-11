package org.apache.catalina.loader.maven;

import java.io.File;

public class Repository {

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
  }

  public static class Local {

    public final String base;

    public Local(String base) {
      if (null == base) {
        this.base = System.getProperty("user.home") + "/.m2/repository";
      } else {
        if (base.endsWith("/")) this.base = base.substring(0, base.length() - 1);
        else this.base = base;
      }
      new File(this.base).mkdirs();
    }

    public String path(Artifact artifact) {
      return base + "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/"
          + artifact.version + "/" + artifact.artifactId + "-" + artifact.version + "." + artifact.packaging;
    }
  }

  public static class Remote {

    public final String base;

    public Remote() {
      this("http://central.maven.org/maven2");
    }

    public Remote(String baseUrl) {
      super();
      String httpBase = baseUrl;
      if (!(baseUrl.startsWith("http://") || baseUrl.startsWith("https://"))) httpBase = "http://" + baseUrl;

      if (httpBase.endsWith("/")) base = httpBase.substring(0, baseUrl.length() - 1);
      else base = httpBase;
    }

    public String url(Artifact artifact) {
      return base + "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/"
          + artifact.version + "/" + artifact.artifactId + "-" + artifact.version + "." + artifact.packaging;
    }
  }
}
