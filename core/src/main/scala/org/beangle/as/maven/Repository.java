package org.beangle.as.maven;

import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.beangle.as.util.Delta;

public class Repository {

  public static class Local {

    public final String base;

    public Local() {
      this(System.getProperty("user.home") + "/.m2/repository");
    }

    public Local(String base) {
      if (base.endsWith("/")) this.base = base.substring(0, base.length() - 1);
      else this.base = base;
      new java.io.File(this.base).mkdirs();
    }

    public String path(Product f) {
      if (f instanceof Artifact) {
        return base + Layout.path((Artifact) f);
      } else {
        return base + Layout.path((Diff) f);
      }
    }

    public boolean exists(Artifact artifact) {
      return new File(this.path(artifact)).exists();
    }

    public boolean verifySha1(Artifact artifact) {
      Artifact sha1 = artifact.sha1();
      if (exists(artifact) && exists(sha1)) {
        String sha1sum = Delta.sha1(path(artifact));
        char[] sha1chars = new char[40];
        try {
          FileReader fr = new FileReader(path(sha1));
          fr.read(sha1chars);
          fr.close();
        } catch (Exception e) {
          throw new RuntimeException(e);
        }
        String sha1inFile = new String(sha1chars);
        if (!sha1sum.startsWith(sha1inFile)) {
          System.out.println("Error sha1 for " + artifact + ",Remove it.");
          new File(path(artifact)).delete();
          return false;
        }
      }
      return true;
    }

    public Artifact lastest(Artifact artifact) {
      File parent = new File(path(artifact)).getParentFile().getParentFile();
      if (parent.exists()) {
        String[] siblings = parent.list();
        List<String> versions = new ArrayList<String>();
        for (String sibling : siblings) {
          if (!sibling.contains("SNAPSHOT")
              && new File(parent.getAbsolutePath() + File.separator + sibling).isDirectory()) {
            if (sibling.compareTo(artifact.version) < 0) {
              versions.add(sibling);
            }
          }
        }
        Collections.sort(versions);
        if (versions.isEmpty()) return null;
        else return artifact.forVersion(versions.get(versions.size() - 1));
      } else {
        return null;
      }
    }
  }

  public static class Remote {

    public final String base;

    public Remote() {
      this("http://repo1.maven.org/maven2");
    }

    public Remote(String baseUrl) {
      super();
      String httpBase = baseUrl;
      if (!(baseUrl.startsWith("http://") || baseUrl.startsWith("https://"))) httpBase = "http://" + baseUrl;

      if (httpBase.endsWith("/")) base = httpBase.substring(0, baseUrl.length() - 1);
      else base = httpBase;
    }

    public String url(Product f) {
      if (f instanceof Artifact) {
        return base + Layout.path((Artifact) f);
      } else {
        return base + Layout.path((Diff) f);
      }
    }
  }
}
