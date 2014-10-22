package org.beangle.tomcat.jdbc

import java.io.UnsupportedEncodingException
import java.security.InvalidKeyException
import java.security.Key
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.Arrays

import javax.crypto.BadPaddingException
import javax.crypto.Cipher
import javax.crypto.IllegalBlockSizeException
import javax.crypto.KeyGenerator
import javax.crypto.NoSuchPaddingException
import javax.crypto.spec.SecretKeySpec

/**
 * Provider encrypt/decrypt utility with secret key.
 *
 * @author chaostone
 * @see http://www.idesign4all.nl/blog/?p=103
 */
class Encryptor(initkey: String) {

  private val ALGORITHM = "AES"

  private val defaultSecretKey = "changeit"

  private val secretKeySpec: Key = generateKey(initkey)

  def encrypt(plainText: String): String = {
    val cipher = Cipher.getInstance(ALGORITHM)
    cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec)
    asHexString(cipher.doFinal(plainText.getBytes("UTF-8")))
  }

  def decrypt(encryptedString: String): String = {
    val cipher = Cipher.getInstance(ALGORITHM)
    cipher.init(Cipher.DECRYPT_MODE, secretKeySpec)
    new String(cipher.doFinal(toByteArray(encryptedString)))
  }

  private def generateKey(keyStr: String): Key = {
    val secretKey = if (keyStr == null) defaultSecretKey else keyStr
    var key = secretKey.getBytes("UTF-8")
    val sha = MessageDigest.getInstance("SHA-1")
    key = sha.digest(key)
    key = Arrays.copyOf(key, 16); // use only the first 128 bit

    val kgen = KeyGenerator.getInstance("AES")
    kgen.init(128); // 192 and 256 bits may not be available

    new SecretKeySpec(key, ALGORITHM)
  }

  private def asHexString(buf: Array[Byte]): String = {
    val strbuf = new StringBuffer(buf.length * 2)
    (0 until buf.length) foreach { i =>
      if ((buf(i).asInstanceOf[Int] & 0xff) < 0x10) {
        strbuf.append("0")
      }
      strbuf.append(java.lang.Long.toString(buf(i).asInstanceOf[Int] & 0xff, 16))
    }
    strbuf.toString
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
}

object Encryptor {
  def main(args: Array[String]) {
    if (args.length == 1 || args.length == 2) {
      val secretKey = if (args.length == 2) args(1) else null
      println(args(0) + ":" + new Encryptor(secretKey).encrypt(args(0)))
    } else {
      println("USAGE: java Encryptor string-to-encrypt [secretKey]")
    }
  }
}