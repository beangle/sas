package org.beangle.sas.config.model

import org.beangle.maven.artifact.Artifact
import java.net.URL
import org.beangle.commons.lang.Strings
import java.io.File

class Engine(var name: String, var typ: String, var version: String) {
  var context: Context = _

  val listeners = new collection.mutable.ListBuffer[Listener]

  val jars = new collection.mutable.ListBuffer[Jar]
}

class Listener(val className: String) {

  var properties = new collection.mutable.HashMap[String, String]
}

class Context {
  var loader: Loader = _
  var jarScanner: JarScanner = _
}

class Loader(var className: String) {
  var properties = new collection.mutable.HashMap[String, String]
}

class JarScanner {
  var properties = new collection.mutable.HashMap[String, String]
}

object Jar {
  def gav(str: String): Jar = {
    val j = new Jar
    j.gav = Some(str)
    j
  }
}
class Jar {
  var gav: Option[String] = None
  var url: Option[String] = None
  var path: Option[String] = None

  def name: String = {
    if (gav.isDefined) {
      val a = Artifact(gav.get)
      a.artifactId + "-" + a.version + "." + a.packaging
    } else if (url.isDefined) {
      val f = new URL(url.get).getFile
      Strings.substringAfterLast(f, "/")
    } else if (path.isDefined) {
      new File(path.get).getName
    } else {
      throw new RuntimeException("Invalid jar format")
    }
  }
}
