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
package org.beangle.tomcat.configer.util

import java.beans.PropertyDescriptor
import java.io.{ File, StringWriter }
import java.lang.reflect.{ Method, Modifier }
import scala.collection.JavaConversions
import org.beangle.commons.io.Files
import org.beangle.commons.lang.Strings
import org.beangle.tomcat.configer.model.{ Container, Farm, Server }
import freemarker.cache.ClassTemplateLoader
import freemarker.ext.beans.BeansWrapper.MethodAppearanceDecision
import freemarker.template.{ Configuration, DefaultObjectWrapper, TemplateModel }
import org.beangle.template.freemarker.FreemarkerConfigurer

object Template {
  val cfg =  FreemarkerConfigurer.newConfig

  def generate(container: Container, farm: Farm, targetDir: String) {
    for (server <- farm.servers) {
      generate(container, farm, server, targetDir)
    }
  }

  def generate(container: Container, farm: Farm, server: Server, targetDir: String) {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    data.put("server", server)
    val sw = new StringWriter()
    val freemarkerTemplate = cfg.getTemplate("tomcat/conf/server.xml.ftl")
    freemarkerTemplate.process(data, sw)
    val serverDir = targetDir + "/servers/" + server.qualifiedName
    new File(serverDir).mkdirs()
    Files.writeString(new File(serverDir + "/conf/server.xml"), sw.toString)

    if (Strings.isNotBlank(farm.jvmopts)) {
      val envTemplate = cfg.getTemplate("tomcat/bin/setenv.sh.ftl")
      val nsw = new StringWriter()
      envTemplate.process(data, nsw)
      new File(serverDir + "/bin").mkdirs()
      val target = new File(serverDir + "/bin/setenv.sh")
      Files.writeString(target, nsw.toString)
      target.setExecutable(true)
    }
  }
}
