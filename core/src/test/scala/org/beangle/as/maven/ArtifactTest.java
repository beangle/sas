package org.beangle.as.maven;

import org.junit.Assert;
import org.junit.Test;

public class ArtifactTest {
  Artifact older = new Artifact("org.beangle.commons", "beangle-commons-core_2.12", "4.6.1", "sources", "jar");
  Artifact artifact = new Artifact("org.beangle.commons", "beangle-commons-core_2.12", "4.6.2", "sources",
      "jar");
  Repository.Local local = new Repository.Local("/home/chaostone/.m2/repository");

  @Test
  public void testToString() {
    Assert.assertEquals("org.beangle.commons:beangle-commons-core_2.12:4.6.2:sources:jar",
        artifact.toString());
  }

  @Test
  public void testPath() {
    String loc = local.path(artifact);
    Assert.assertEquals("/home/chaostone/.m2/repository/org/beangle/commons/beangle-commons-core_2.12"
        + "/4.6.2/beangle-commons-core_2.12-4.6.2-sources.jar", loc);
  }

  @Test
  public void testDiff(){
    Diff diff=new Diff(older,"4.6.2");
    Assert.assertTrue(local.path(diff).contains("org/beangle/commons/beangle-commons-core_2.12/4.6.2/beangle-commons-core_2.12-4.6.1_4.6.2-sources.jar.diff"));
  }
}
