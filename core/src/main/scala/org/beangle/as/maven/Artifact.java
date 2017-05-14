package org.beangle.as.maven;

public class Artifact implements Product {
  public final String groupId;
  public final String artifactId;
  public final String version;
  public final String packaging;
  public final String classifier;

  public Artifact(String gav) {
    String[] infos = gav.split(":");
    this.groupId = infos[0];
    this.artifactId = infos[1];
    int classifierIdx = infos[2].indexOf('-');
    if (-1 == classifierIdx) {
      this.classifier = null;
      this.version = infos[2];
    } else {
      this.classifier = infos[2].substring(classifierIdx + 1);
      this.version = infos[2].substring(0, classifierIdx);
    }
    this.packaging = (infos.length > 3) ? infos[3] : "jar";
  }

  public Artifact(String groupId, String artifactId, String version, String classifier, String packaging) {
    super();
    this.groupId = groupId;
    this.artifactId = artifactId;
    this.version = version;
    this.classifier = classifier;
    this.packaging = packaging;
  }

  public Artifact sha1() {
    return new Artifact(groupId, artifactId, version, classifier, packaging + ".sha1");
  }
  @Override
  public String toString() {
    return groupId + ":" + artifactId + ":" + version + (null == classifier ? "" : (":" + classifier)) + ":"
        + packaging;
  }

  public Artifact forVersion(String newVersion) {
    return new Artifact(groupId, artifactId, newVersion, classifier, packaging);
  }

  @Override
  public int hashCode() {
    return toString().hashCode();
  }

  @Override
  public boolean equals(Object obj) {
    if (obj instanceof Artifact) {
      Artifact o = (Artifact) obj;
      return this.groupId.equals(o.groupId) && this.artifactId.equals(o.artifactId)
          && this.version.equals(o.version) && this.classifier.equals(o.classifier)
          && this.packaging.equals(o.packaging);
    } else {
      return false;
    }
  }

}
