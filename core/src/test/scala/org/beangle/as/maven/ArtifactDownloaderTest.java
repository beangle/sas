package org.beangle.as.maven;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

public class ArtifactDownloaderTest {

  Artifact slf4j_1_7_24 = new Artifact("org.slf4j", "slf4j-api", "1.7.24", null, "jar");
  Artifact slf4j_1_7_25 = new Artifact("org.slf4j", "slf4j-api", "1.7.25", null, "jar");

  @Test
  public void testMd5() {
    Repository.Local local = new Repository.Local();
    Repository.Remote remote = new Repository.Remote();
    ArtifactDownloader downloader = new ArtifactDownloader(remote, local);
    List<Artifact> artifacts = new ArrayList<Artifact>();
    artifacts.add(slf4j_1_7_24);
    artifacts.add(slf4j_1_7_25);
    downloader.download(artifacts);
  }
}
