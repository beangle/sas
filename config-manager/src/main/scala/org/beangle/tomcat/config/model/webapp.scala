package org.beangle.tomcat.config.model

class Webapp {

  var docBase: String = "webapps"

  var contexts = new collection.mutable.ListBuffer[Context]
}

class Context(var path: String) {

  var dataSources = new collection.mutable.ListBuffer[DataSource]

  var runAt: String = _

  var reloadable = false
}

class DataSource(var name: String) {

  var url: String = _

  var username: String = _

}