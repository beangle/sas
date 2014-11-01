package org.apache.catalina.loader

import java.io.File

class RemoteRepository(val base: String) {

  def url(artifact: Artifact): String = {
    s"$base/${artifact.groupId.replace('.', '/')}/${artifact.artifactId}/${artifact.version}/${artifact.artifactId}-${artifact.version}.jar"
  }
}

class LocalRepository(val base: String, val layout: String) {
  new File(base).mkdirs()

  def path(artifact: Artifact): String = {
    layout match {
      case "maven2" => s"${base}/${artifact.groupId.replace('.', '/')}/${artifact.artifactId}/${artifact.version}/${artifact.artifactId}-${artifact.version}.jar"
      case "ivy2" => s"${base}/${artifact.groupId}/${artifact.artifactId}/jars/${artifact.artifactId}-${artifact.version}.jar"
      case _ => throw new RuntimeException("Do not support layout $layout,Using maven2 or ivy2")
    }
  }
}
