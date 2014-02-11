package org.beangle.tomcat.config.model

class Configuration {

  var farms = new collection.mutable.ListBuffer[Farm]

  var webapp = new Webapp
}