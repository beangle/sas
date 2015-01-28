package org.beangle.tomcat.configurer.model

class Listener(val className: String) {

  var properties = new collection.mutable.HashMap[String, String]
}