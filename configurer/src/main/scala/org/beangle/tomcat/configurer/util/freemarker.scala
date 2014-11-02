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
package org.beangle.tomcat.configurer.util

import java.beans.PropertyDescriptor
import java.io.{ File, StringWriter }
import java.lang.reflect.{ Method, Modifier }

import scala.collection.JavaConversions

import org.beangle.commons.io.Files
import org.beangle.tomcat.configurer.model.{ Container, Context, Farm, Server }

import freemarker.cache.ClassTemplateLoader
import freemarker.ext.beans.BeansWrapper.MethodAppearanceDecision
import freemarker.template.{ Configuration, DefaultObjectWrapper, TemplateModel }

class ScalaObjectWrapper extends DefaultObjectWrapper {

  override def wrap(obj: Object): TemplateModel = {
    return super.wrap(convert2Java(obj));
  }

  protected override def finetuneMethodAppearance(clazz: Class[_], m: Method,
    decision: MethodAppearanceDecision) {
    val name = m.getName
    if (name.equals("hashCode") || name.equals("toString")) return
    if (isPropertyMethod(m)) {
      val pd = new PropertyDescriptor(name, m, null);
      decision.setExposeAsProperty(pd)
      decision.setExposeMethodAs(name)
      decision.setMethodShadowsProperty(false)
    }
  }

  private def convert2Java(obj: Any): Any = {
    obj match {
      case Some(inner) => convert2Java(inner)
      case None => null
      case seq: collection.Seq[_] => JavaConversions.seqAsJavaList(seq)
      case map: collection.Map[_, _] => JavaConversions.mapAsJavaMap(map)
      case iter: Iterable[_] => JavaConversions.asJavaIterable(iter)
      case _ => obj
    }
  }

  private def isPropertyMethod(m: Method): Boolean = {
    val name = m.getName
    return (m.getParameterTypes().length == 0 && classOf[Unit] != m.getReturnType() && Modifier.isPublic(m.getModifiers())
      && !Modifier.isStatic(m.getModifiers()) && !Modifier.isSynchronized(m.getModifiers()) && !name.startsWith("get") && !name.startsWith("is"))
  }
}

object Template {
  val cfg = new Configuration()
  cfg.setTemplateLoader(new ClassTemplateLoader(getClass, "/"))
  cfg.setObjectWrapper(new ScalaObjectWrapper())
  cfg.setNumberFormat("0.##")

  def generate(container: Container, farm: Farm, server: Server, targetDir: String) {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    data.put("server", server)
    val sw = new StringWriter()
    val freemarkerTemplate = cfg.getTemplate("tomcat/conf/server.xml.ftl")
    freemarkerTemplate.process(data, sw)
    Files.writeString(new File(targetDir + "/" + farm.name + "/conf/" + server.name + ".xml"), sw.toString)
  }

  def generate(container: Container, farm: Farm, context: Context, targetDir: String) {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    data.put("context", context)
    val sw = new StringWriter()
    val path = "/conf/Catalina/localhost"
    val freemarkerTemplate = cfg.getTemplate("tomcat" + path + "/context.xml.ftl")
    freemarkerTemplate.process(data, sw)
    Files.writeString(new File(targetDir + "/" + farm.name + path + "/" + context.name + ".xml"), sw.toString)
  }

  def generateEnv(container: Container, farm: Farm, targetDir: String) {
    val data = new collection.mutable.HashMap[String, Any]()
    data.put("container", container)
    data.put("farm", farm)
    val sw = new StringWriter()
    val path = "/bin"
    val freemarkerTemplate = cfg.getTemplate("tomcat" + path + "/setenv.sh.ftl")
    freemarkerTemplate.process(data, sw)
    val target = new File(targetDir + "/" + farm.name + path + "/setenv.sh")
    Files.writeString(target, sw.toString)
    target.setExecutable(true)
  }
}
