package org.beangle.sas.model

import org.beangle.commons.bean.Properties
import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings

import scala.collection.mutable

object Proxy {
  def getDefault: Proxy = {
    new Proxy
  }

  class Backend(var name: String, var servers: String) {
    var options: String = _

    def getServers(container: Container): List[Server] = {
      container.getMatchedServers(servers)
    }

    def contains(server: Server): Boolean = {
      val sname = server.qualifiedName
      if (sname == servers) {
        true
      } else {
        val res = servers.split(",") find (one => one == sname || sname.startsWith(one + "."))
        res.isDefined
      }
    }
  }

}

import org.beangle.sas.model.Proxy.Backend

class Proxy {
  /** 主机 */
  var hostname: Option[String] = None
  /** 最大连接数 */
  var maxconn: Int = 15000
  /** 是否启用https */
  var enableHttps: Boolean = _
  /** 后端主机列表设置 */
  val backends: mutable.Map[String, Backend] = Collections.newMap[String, Backend]

  def update(proxy: Proxy): Unit = {
    this.hostname = proxy.hostname
    this.maxconn = proxy.maxconn
    this.enableHttps = proxy.enableHttps
  }

  def getBackend(backendName: String): Backend = {
    var name = backendName
    name = Strings.replace(name, ",", "_")
    name = Strings.replace(name, ".", "_")
    backends.get(name) match {
      case None =>
        val backend = new Backend(name, backendName)
        backend.options = "balance roundrobin"
        backends.put(name, backend)
        backend
      case Some(b) => b
    }
  }

  def addBackend(backend: Backend): this.type = {
    backends.put(backend.name, backend)
    this
  }

  def process(template: String): String = {
    if (template.contains("{")) {
      var updates = template
      var name = Strings.substringBetween(updates, "${", "}")
      while (Strings.isNotBlank(name)) {
        val value: Any = Properties.get(this, name)
        val str = value match {
          case Some(v) => String.valueOf(v)
          case None => ""
          case _ => String.valueOf(value)

        }
        updates = Strings.replace(updates, "${" + name + "}", str)
        name = Strings.substringBetween(updates, "${", "}")
      }
      updates
    } else {
      template
    }
  }
}
