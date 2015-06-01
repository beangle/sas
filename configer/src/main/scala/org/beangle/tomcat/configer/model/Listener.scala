package org.beangle.tomcat.configer.model

class Listener(val className: String) {

  var properties = new collection.mutable.HashMap[String, String]
}