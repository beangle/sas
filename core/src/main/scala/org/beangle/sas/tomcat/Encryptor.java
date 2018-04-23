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
package org.beangle.sas.tomcat;

import java.security.Key;
import java.security.MessageDigest;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

/**
 * Provider encrypt/decrypt utility with secret key.
 *
 * @author chaostone
 * @see http://www.idesign4all.nl/blog/?p=103
 */
class Encryptor {

  private final String ALGORITHM = "AES";

  private final String defaultSecretKey = "changeit";

  private final Key secretKeySpec;

  public Encryptor(String initkey) throws Exception {
    super();
    secretKeySpec = generateKey(initkey);
  }

  public String encrypt(String plainText) throws Exception {
    Cipher cipher = Cipher.getInstance(ALGORITHM);
    cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
    return asHexString(cipher.doFinal(plainText.getBytes("UTF-8")));
  }

  public String decrypt(String encryptedString) throws Exception {
    Cipher cipher = Cipher.getInstance(ALGORITHM);
    cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
    return new String(cipher.doFinal(toByteArray(encryptedString)));
  }

  private Key generateKey(String keyStr) throws Exception {
    String secretKey = (keyStr == null) ? defaultSecretKey : keyStr;
    byte[] key = secretKey.getBytes("UTF-8");
    MessageDigest sha = MessageDigest.getInstance("SHA-1");
    key = sha.digest(key);
    key = Arrays.copyOf(key, 16); // use only the first 128 bit
    return new SecretKeySpec(key, ALGORITHM);
  }

  private String asHexString(byte[] buf) {
    StringBuffer strbuf = new StringBuffer(buf.length * 2);
    for (int i = 0; i < buf.length; i++) {
      if ((buf[i] & 0xff) < 0x10) strbuf.append("0");
      strbuf.append(java.lang.Long.toString(buf[i] & 0xff, 16));
    }
    return strbuf.toString();
  }

  private byte[] toByteArray(String hexString) {
    int arrLength = hexString.length() >> 1;
    byte[] buf = new byte[arrLength];
    for (int ii = 0; ii < arrLength; ii++) {
      int index = ii << 1;
      String l_digit = hexString.substring(index, index + 2);
      buf[ii] = (byte) Integer.parseInt(l_digit, 16);
    }
    return buf;
  }

  public static void main(String... args) throws Exception {
    if (args.length == 1 || args.length == 2) {
      String secretKey = (args.length == 2) ? args[1] : null;
      System.out.println(args[0] + ":" + new Encryptor(secretKey).encrypt(args[0]));
    } else {
      System.out.println("USAGE: java Encryptor string-to-encrypt [secretKey]");
    }
  }
}
