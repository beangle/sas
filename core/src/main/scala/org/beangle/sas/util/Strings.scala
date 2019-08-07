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
package org.beangle.sas.util

object Strings {

  /**
    * Return true if cs not null and cs has length.
    */
  @inline
  def isNotEmpty(cs: CharSequence): Boolean = !(cs eq null) && cs.length > 0

  @inline
  def isEmpty(cs: CharSequence): Boolean = (cs eq null) || 0 == cs.length

  def isBlank(cs: CharSequence): Boolean = {
    if ((cs eq null) || cs.length == 0) return true
    val strLen = cs.length
    for (i <- 0 until strLen if !Character.isWhitespace(cs.charAt(i))) return false
    true
  }

  def isNotBlank(cs: CharSequence): Boolean = !isBlank(cs)

  def toInt(str: String, defaultValue: Int = 0): Int = {
    if (isEmpty(str)) return defaultValue
    try {
      Integer.parseInt(str)
    } catch {
      case _: NumberFormatException => defaultValue
    }
  }

  def substringAfter(str: String, separator: String): String = {
    if (isEmpty(str)) return str
    if (separator == null) return ""
    val pos = str.indexOf(separator)
    if (pos == -1) return ""
    str.substring(pos + separator.length)
  }

  def substringAfterLast(str: String, separator: String): String = {
    if (isEmpty(str)) return str
    if (isEmpty(separator)) return ""
    val pos = str.lastIndexOf(separator)
    if (pos == -1 || pos == str.length - separator.length) return ""
    str.substring(pos + separator.length)
  }

}
