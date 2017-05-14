package org.beangle.as.maven;

public class Diff implements Product {
  public final String groupId;
  public final String artifactId;
  public final String oldVersion;
  public final String newVersion;
  public final String packaging;
  public final String classifier;

  public Diff(String groupId, String artifactId, String oldVersion, String newVersion, String classifier,
      String packaging) {
    super();
    this.groupId = groupId;
    this.artifactId = artifactId;
    this.oldVersion = oldVersion;
    this.newVersion = newVersion;
    this.packaging = packaging;
    this.classifier = classifier;
  }

  public Diff(Artifact old, String newVersion) {
    this.groupId = old.groupId;
    this.artifactId = old.artifactId;
    this.oldVersion = old.version;
    this.newVersion = newVersion;
    this.packaging = old.packaging + ".diff";
    this.classifier = old.classifier;
  }

  public Artifact older() {
    return new Artifact(groupId, artifactId, oldVersion, classifier, packaging.replace(".diff", ""));
  }

  public Artifact newer() {
    return new Artifact(groupId, artifactId, newVersion, classifier, packaging.replace(".diff", ""));
  }
}
