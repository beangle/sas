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
package org.beangle.tomcat.config.shell

import java.io.{ File, FileInputStream }
import org.beangle.commons.lang.SystemInfo
import org.beangle.tomcat.config.model.TomcatConfig
import org.beangle.tomcat.config.util.Template
import org.beangle.data.jdbc.vendor.Vendors
import org.beangle.commons.lang.Consoles
import org.beangle.tomcat.jdbc.Encryptor

object Generator {
  def main(args: Array[String]) {
    val workdir = SystemInfo.user.dir
    val target = new File(workdir + "/config.xml")
    if (target.exists()) {
      val conf = TomcatConfig(scala.xml.XML.load(new FileInputStream(target)))
      for (farm <- conf.farms; server <- farm.servers) {
        Template.generate(conf, farm, server, workdir)
      }
      for (context <- conf.webapp.contexts) {
        conf.farms.find(f => f.name == context.runAt).foreach { farm =>
          for (ds <- context.dataSources) {
            if (null == ds.driverClassName) {
              ds.driverClassName = Vendors.drivers.get(ds.driver) match {
                case Some(di) => di.className
                case None => println("cannot find driver " + ds.driver + "className"); "unknown"
              }
            }
            if (null == ds.password) ds.password = new Encryptor(null).encrypt(Consoles.readPassword("enter datasource [%1$s] %2$s password:", ds.name, ds.username))
          }
          Template.generate(conf, farm, context, workdir)
        }
      }
    } else
      println("Cannot find tomcat-config.xml")
  }

}