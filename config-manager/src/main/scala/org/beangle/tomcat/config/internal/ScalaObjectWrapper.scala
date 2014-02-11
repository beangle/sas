/*
 * Beangle, Agile Java/Scala Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2013, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.tomcat.config.internal

import java.beans.PropertyDescriptor
import java.lang.reflect.{Method, Modifier}

import scala.collection.JavaConversions

import freemarker.ext.beans.BeansWrapper.MethodAppearanceDecision
import freemarker.template.{DefaultObjectWrapper, TemplateModel}

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