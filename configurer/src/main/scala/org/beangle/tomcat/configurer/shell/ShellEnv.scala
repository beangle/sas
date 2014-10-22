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
package org.beangle.tomcat.configurer.shell

import org.beangle.commons.logging.Logging
import org.beangle.tomcat.configurer.model.Container
import java.io.FileInputStream
import java.io.File
import java.io.StringWriter
import freemarker.template.Configuration
import freemarker.cache.ClassTemplateLoader
import org.beangle.tomcat.configurer.util.ScalaObjectWrapper
import org.beangle.commons.io.Files./
trait ShellEnv extends Logging {

  var workdir: String = _

  var container: Container = _

  def read() = {
    assert(null != workdir)
    val target = new File(workdir + / + "config.xml")
    if (target.exists) {
      info(s"Read config file ${target.getName}")
      container = Container(scala.xml.XML.load(new FileInputStream(target)))
    }
  }

  def toXml: String = {
    val cfg = new Configuration()
    cfg.setTemplateLoader(new ClassTemplateLoader(getClass, "/"))
    cfg.setObjectWrapper(new ScalaObjectWrapper())
    cfg.setNumberFormat("0.##")
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    val sw = new StringWriter()
    val freemarkerTemplate = cfg.getTemplate("tomcat/config.xml.ftl")
    freemarkerTemplate.process(data, sw)
    sw.close()
    sw.toString()
  }
}