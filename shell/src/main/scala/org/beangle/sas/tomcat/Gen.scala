/*
 * Beangle, Agile Development Scaffold and Toolkits.
 *
 * Copyright © 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.tomcat

import java.io.{File, StringWriter}

import freemarker.template.Configuration
import org.beangle.commons.activation.MediaTypes
import org.beangle.commons.config.Resources
import org.beangle.commons.io.{Files => IOFiles}
import org.beangle.commons.lang.ClassLoaders.getResource
import org.beangle.sas.model.{Container, Engine, Farm, Server}
import org.beangle.template.freemarker.Configurer

object Gen {
  private val cfg = Configurer.newConfig
  cfg.setTagSyntax(Configuration.SQUARE_BRACKET_TAG_SYNTAX)
  cfg.setDefaultEncoding("UTF-8")
  cfg.setNumberFormat("0.##")

  def spawn(container: Container, farm: Farm, server: Server, targetDir: String): Unit = {
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

  def spawn(engine: Engine, engineDir: String): Unit = {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("engine", engine)
    val mimetypes = MediaTypes.buildTypes(new Resources(None,
      List.empty, getResource("sas/mime.types")))
    data.put("mimetypes", mimetypes)
    val envTemplate = cfg.getTemplate(s"${engine.typ}/conf/web.xml.ftl")
    val nsw = new StringWriter()
    envTemplate.process(data, nsw)
    IOFiles.writeString(new File(engineDir + "/conf/web.xml"), nsw.toString)
  }
}
