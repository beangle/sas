package org.apache.catalina.loader.maven;

import java.io.File;

public class Repository {

  public static class Artifact {

    public final String groupId;
    public final String artifactId;
    public final String version;

    public Artifact(String groupId, String artifactId, String version) {
      super();
      this.groupId = groupId;
      this.artifactId = artifactId;
      this.version = version;
    }
  }

  public static class Local {
    public static final String Maven2 = "maven2";
    public static final String Ivy2 = "ivy2";

    public final String base;
    public final String layout;

    public Local() {
      this(Maven2, null);
    }

    public Local(String layout, String base) {
      this.layout = layout;
      if (null == base) {
        if (layout.equals(Maven2)) {
          this.base = System.getProperty("user.home") + "/.m2/repository";
        } else if (layout.equals("ivy2")) {
          this.base = System.getProperty("user.home") + "/.ivy2/cache";
        } else {
          throw new RuntimeException("Do not support layout $layout,Using maven2 or ivy2");
        }
      } else {
        if (base.endsWith("/")) this.base = base.substring(0, base.length() - 1);
        else this.base = base;
      }
      new File(this.base).mkdirs();
    }

    public String path(Artifact artifact) {
      if (layout.equals(Maven2)) {
        return base + "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/"
            + artifact.version + "/" + artifact.artifactId + "-" + artifact.version + ".jar";
      } else if (layout.equals(Ivy2)) {
        return base + "/" + artifact.groupId + "/" + artifact.artifactId + "/jars/" + artifact.artifactId
            + "-" + artifact.version + ".jar";
      } else {
        throw new RuntimeException("Do not support layout $layout,Using maven2 or ivy2");
      }
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
          + artifact.version + "/" + artifact.artifactId + "-" + artifact.version + ".jar";
    }
  }
}
