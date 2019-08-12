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
package org.beangle.sas.shell

import java.security.{Key, MessageDigest}
import java.{util => ju}

import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

object Aes {

  val ALGORITHM = "AES"

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      println("Usage:Aes key plain|encoded")
      return
    }
    if (args(1).length == 32) {
      println(new Aes(args(0)).decrypt(args(1)))
    } else {
      println(new Aes(args(0)).encrypt(args(1)))
    }
  }

}


class Aes(initkey: String) {
  val secretKeySpec: Key = generateKey(initkey)

  import Aes._

  private def generateKey(secretKey: String): Key = {
    var key = secretKey.getBytes("UTF-8")
    val sha = MessageDigest.getInstance("SHA-1")
    key = sha.digest(key)
    key = ju.Arrays.copyOf(key, 16); // use only the first 128 bit
    new SecretKeySpec(key, ALGORITHM)
  }

  def encrypt(plain: String): String = {
    val cipher = Cipher.getInstance(ALGORITHM)
    cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec)
    asHexString(cipher.doFinal(plain.getBytes("UTF-8")))
  }

  def decrypt(encrypted: String): String = {
    val cipher = Cipher.getInstance(ALGORITHM)
    cipher.init(Cipher.DECRYPT_MODE, secretKeySpec)
    new String(cipher.doFinal(toByteArray(encrypted)))
  }

  private def toByteArray(hexString: String): Array[Byte] = {
    val arrLength = hexString.length() >> 1
    val buf = new Array[Byte](arrLength)
    (0 until arrLength) foreach { ii =>
      val index = ii << 1
      val l_digit = hexString.substring(index, index + 2)
      buf(ii) = Integer.parseInt(l_digit, 16).asInstanceOf[Byte]
    }
    buf
  }

  private def asHexString(buf: Array[Byte]): String = {
    val strbuf = new StringBuffer(buf.length * 2)
    buf.indices foreach { i =>
      if ((buf(i) & 0xff) < 0x10) strbuf.append("0")
      strbuf.append(java.lang.Long.toString(buf(i) & 0xff, 16))
    }
    strbuf.toString
  }

}
