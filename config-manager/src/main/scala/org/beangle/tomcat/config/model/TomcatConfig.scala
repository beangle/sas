package org.beangle.tomcat.config.model

class TomcatConfig {

  val farms = new collection.mutable.ListBuffer[Farm]

  val webapp = new Webapp

  def farmNames: Set[String] = farms.map(f => f.name).toSet
}