/*
 * Copyright (C) 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.beangle.sas.config

class Resource(var name: String) {

  def url: String = {
    properties.getProperty("url")
  }

  def url_=(newUrl: String): Unit = {
    properties.setProperty("url", newUrl)
  }

  def username: String = {
    properties.getProperty("username")
  }

  def `type`: String = {
    properties.getProperty("type")
  }

  def username_=(newName: String): Unit = {
    properties.setProperty("username", newName)
  }

  def driverClassName: String = {
    properties.getProperty("driverClassName")
  }

  def driverClassName_=(newName: String): Unit = {
    properties.setProperty("driverClassName", newName)
  }

  def password: String = {
    properties.getProperty("password")
  }

  def password_=(newer: String): Unit = {
    properties.setProperty("password", newer)
  }

  import java.{util => ju}

  val properties = new ju.Properties

  override def toString: String = {
    name + properties
  }
}
