package org.beangle.as.config.model

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