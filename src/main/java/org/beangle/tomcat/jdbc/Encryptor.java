package org.beangle.tomcat.jdbc;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

/**
 * Provider encrypt/decrypt utility with secret key.
 * 
 * @author chaostone
 * @see http://www.idesign4all.nl/blog/?p=103
 */
public class Encryptor {

  private static final String ALGORITHM = "AES";

  private static final String defaultSecretKey = "changeit";

  private Key secretKeySpec;

  public Encryptor(String secretKey) {
    this.secretKeySpec = generateKey(secretKey);
  }

  public String encrypt(String plainText) throws InvalidKeyException, NoSuchAlgorithmException,
      NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
    Cipher cipher = Cipher.getInstance(ALGORITHM);
    cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
    return asHexString(cipher.doFinal(plainText.getBytes("UTF-8")));
  }

  public String decrypt(String encryptedString) throws InvalidKeyException, IllegalBlockSizeException,
      BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException {
    Cipher cipher = Cipher.getInstance(ALGORITHM);
    cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
    return new String(cipher.doFinal(toByteArray(encryptedString)));
  }

  private Key generateKey(String secretKey) {
    if (secretKey == null) secretKey = defaultSecretKey;
    try {
      byte[] key = secretKey.getBytes("UTF-8");
      MessageDigest sha = MessageDigest.getInstance("SHA-1");
      key = sha.digest(key);
      key = Arrays.copyOf(key, 16); // use only the first 128 bit

      KeyGenerator kgen = KeyGenerator.getInstance("AES");
      kgen.init(128); // 192 and 256 bits may not be available

      return new SecretKeySpec(key, ALGORITHM);
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  private final String asHexString(byte buf[]) {
    StringBuffer strbuf = new StringBuffer(buf.length * 2);
    int i;
    for (i = 0; i < buf.length; i++) {
      if (((int) buf[i] & 0xff) < 0x10) {
        strbuf.append("0");
      }
      strbuf.append(Long.toString((int) buf[i] & 0xff, 16));
    }
    return strbuf.toString();
  }

  private final byte[] toByteArray(String hexString) {
    int arrLength = hexString.length() >> 1;
    byte buf[] = new byte[arrLength];
    for (int ii = 0; ii < arrLength; ii++) {
      int index = ii << 1;
      String l_digit = hexString.substring(index, index + 2);
      buf[ii] = (byte) Integer.parseInt(l_digit, 16);
    }
    return buf;
  }

  public static void main(String[] args) throws Exception {
    if (args.length == 1 || args.length == 2) {
      String secretKey = args.length == 2 ? args[1] : null;
      System.out.println(args[0] + ":" + new Encryptor(secretKey).encrypt(args[0]));
    } else {
      System.out.println("USAGE: java Encryptor string-to-encrypt [secretKey]");
    }
  }

}
