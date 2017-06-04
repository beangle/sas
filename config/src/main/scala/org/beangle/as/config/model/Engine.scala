package org.beangle.as.config.model

class Engine(var name: String, var typ: String, var version: String) {
  var context: Context = _

  val listeners = new collection.mutable.ListBuffer[Listener]
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
