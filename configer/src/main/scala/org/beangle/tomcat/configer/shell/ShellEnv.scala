/*
 * Beangle, Agile Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2014, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.tomcat.configer.shell

import java.io.{ File, FileInputStream, StringWriter }

import org.beangle.commons.logging.Logging
import org.beangle.template.freemarker.Configurer
import org.beangle.tomcat.configer.model.Container

trait ShellEnv extends Logging {

  var workdir: String = _

  var container: Container = _

  var configFile = "/conf/server.xml"

  def read() = {
    assert(null != workdir)
    val target = new File(workdir + configFile)
    if (target.exists) {
      logger.info(s"Read config file ${target.getName}")
      container = Container(scala.xml.XML.load(new FileInputStream(target)))
    }
  }

  def toXml: String = {
    val cfg = Configurer.newConfig
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    val sw = new StringWriter()
    val freemarkerTemplate = cfg.getTemplate("tomcat/config.xml.ftl")
    freemarkerTemplate.process(data, sw)
    sw.close()
    sw.toString()
  }
}
