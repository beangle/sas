package org.beangle.tomcat.config.model
import org.beangle.commons.lang.Range.range
object Farm {
  def build(name: String, serverCount: Int): Farm = {
    if (serverCount > 10) throw new RuntimeException("Cannot create farm contain so much servers.")
    val farm = new Farm(name)
    range(0, serverCount).foreach { i =>
      val server1 = new Server("server" + (i + 1), 8005 + i)
      server1.port(8080 + i, 8443 + i, 9009 + i)
      farm.servers += server1
    }
    farm.jvmopts = "-XXmx1G -XXms1G"
    farm
  }
}

class Farm(var name: String) {

  var version = "7.0.50"

  var http = new HttpConnector

  var ajp: AjpConnector = _

  var servers = new collection.mutable.ListBuffer[Server]

  var contexts = new collection.mutable.ListBuffer[Context]

  var jvmopts: String = _
}

class Server(var name: String, var shutdownPort: Int) {

  var httpPort: Int = _

  var httpsPort: Int = _

  var ajpPort: Int = _

  def port(http: Int, https: Int = 0, ajp: Int = 0): this.type = {
    require(http >= 80, "http port should >= 80")
    require(https == 0 || https >= 443, "https port should >=443")
    require(ajp == 0 || ajp >= 1024, "ajp port should >=1024")
    if (https > 0)
      require(http != https, "http port should not equals https port")
    if (ajp > 0)
      require(http != ajp && ajp != https, "ajpport should not equals  http and https port")
    httpPort = http
    httpsPort = https
    ajpPort = ajp
    this
  }
}