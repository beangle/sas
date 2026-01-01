package org.beangle.sas.engine;

public class ConfigTest {
  public static void main(String[] args) {
    assertEquals("", Server.Config.normalizePath(null));
    assertEquals("", Server.Config.normalizePath("/"));
    assertEquals("/api", Server.Config.normalizePath("api"));
    assertEquals("/api", Server.Config.normalizePath("api/"));
    assertEquals("/api", Server.Config.normalizePath("//api"));
  }

  private static void assertEquals(String expected, String result) {
    if (!expected.equals(result)) {
      throw new IllegalArgumentException("not equals:[" + expected + "] , result is [" + result + "]");
    }
  }
}
