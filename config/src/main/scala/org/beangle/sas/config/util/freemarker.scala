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
package org.beangle.sas.config.util

import java.beans.PropertyDescriptor
import java.io.{ File, StringWriter }
import java.lang.reflect.{ Method, Modifier }
import org.beangle.commons.io.{ Files => IOFiles }
import org.beangle.commons.lang.Strings
import org.beangle.commons.template.freemarker.Configurer
import org.beangle.sas.config.model.{ Container, Farm, Server }
import freemarker.cache.ClassTemplateLoader
import freemarker.ext.beans.BeansWrapper.MethodAppearanceDecision
import freemarker.template.{ Configuration, DefaultObjectWrapper, TemplateModel }

object Template {
  val cfg = Configurer.newConfig

  def generate(container: Container, farm: Farm, server: Server, targetDir: String) {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    data.put("server", server)
    val sw = new StringWriter()
    val freemarkerTemplate = cfg.getTemplate(s"${farm.engine.typ}/conf/server.xml.ftl")
    freemarkerTemplate.process(data, sw)
    val serverDir = targetDir + "/servers/" + server.qualifiedName
    new File(serverDir).mkdirs()
    IOFiles.writeString(new File(serverDir + "/conf/server.xml"), sw.toString)

    if (farm.jvmopts.isDefined) {
      val envTemplate = cfg.getTemplate(s"${farm.engine.typ}/bin/setenv.sh.ftl")
      val nsw = new StringWriter()
      envTemplate.process(data, nsw)
      new File(serverDir + "/bin").mkdirs()
      val target = new File(serverDir + "/bin/setenv.sh")
      IOFiles.writeString(target, nsw.toString)
      target.setExecutable(true)
    }
  }
}
