package org.beangle.as.maven;

public class Layout {

  public static String path(Artifact artifact) {
    return "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/" + artifact.version
        + "/" + artifact.artifactId + "-" + artifact.version
        + ((null == artifact.classifier) ? "" : ("-" + artifact.classifier)) + "." + artifact.packaging;
  }

  public static String path(Diff artifact) {
    return "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/" + artifact.newVersion
        + "/" + artifact.artifactId + "-" + artifact.oldVersion + "_" + artifact.newVersion
        + ((null == artifact.classifier) ? "" : ("-" + artifact.classifier)) + "." + artifact.packaging;
  }
}
