package org.beangle.as.config.model

class Listener(val className: String) {

  var properties = new collection.mutable.HashMap[String, String]
}