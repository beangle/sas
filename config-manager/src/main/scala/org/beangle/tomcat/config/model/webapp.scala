package org.beangle.tomcat.config.model

class Webapp {

  var docBase: String = "webapps"

  var contexts = new collection.mutable.ListBuffer[Context]

  def contextPaths: Set[String] = contexts.map(c => c.path).toSet
}

class Context(var path: String) {

  val dataSources = new collection.mutable.ListBuffer[DataSource]

  def dataSourceNames: Set[String] = dataSources.map(d => d.name).toSet

  var runAt: String = _

  var reloadable = false
}

class DataSource(var name: String) {

  var url: String = _

  var driver: String = _

  var username: String = _

}