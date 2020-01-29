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
package org.beangle.sas.haproxy

import java.io.{File, StringWriter}

import freemarker.cache.ClassTemplateLoader
import freemarker.template.Configuration
import org.beangle.commons.collection.Collections
import org.beangle.commons.io.{Files => IOFiles}
import org.beangle.sas.model.{Container, Server}
import org.beangle.template.freemarker.Configurer

object ConfigGenerator {
  private val cfg = Configurer.newConfig
  cfg.setTagSyntax(Configuration.SQUARE_BRACKET_TAG_SYNTAX)
  cfg.setDefaultEncoding("UTF-8")
  cfg.setNumberFormat("0.##")

  def gen(container: Container, workDir: String): Unit = {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    val servers = Collections.newMap[String, List[Server]]
    container.deployments foreach { d =>
      servers.getOrElseUpdate(d.on, container.getMatchedServers(d.on))
    }
    data.put("servers", servers)
    val sw = new StringWriter()
    cfg.setTemplateLoader(new ClassTemplateLoader(getClass, "/haproxy"))
    val freemarkerTemplate = cfg.getTemplate("haproxy.cfg.ftl")
    freemarkerTemplate.process(data, sw)
    new File(workDir).mkdirs()
    IOFiles.writeString(new File(workDir + "/conf/haproxy.cfg"), sw.toString)
  }
}
