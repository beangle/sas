package org.beangle.tomcat.jdbc;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.naming.Context;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.sql.DataSource;

import org.apache.tomcat.jdbc.pool.DataSourceFactory;
import org.apache.tomcat.jdbc.pool.PoolConfiguration;
import org.apache.tomcat.jdbc.pool.XADataSource;

/**
 * Encrypted DataSourceFactory
 *
 * @author chaostone
 * @see http://www.jdev.it/encrypting-passwords-in-tomcat/
 */
class EncryptedDataSourceFactory extends DataSourceFactory {

  @Override
  public DataSource createDataSource(Properties properties, Context context, boolean XA) throws Exception {
    String url = (String) properties.get("url");
    if (null != url && url.startsWith("http")) properties.putAll(parse(getResponseText(new URL(url))));

    PoolConfiguration poolProperties = DataSourceFactory.parsePoolProperties(properties);
    String encodedPwd = poolProperties.getPassword();
    String keyName = poolProperties.getName().replace("/", "_") + "_secret";
    String secretKey = System.getenv(keyName);
    String password = null;

    if (encodedPwd.startsWith("?")) {
      if (null == secretKey) password = decryptByPrompt(keyName, encodedPwd.substring(1));
      else password = new Encryptor(secretKey).decrypt(encodedPwd.substring(1));
    } else {
      password = new Encryptor(secretKey).decrypt(encodedPwd);
    }
    poolProperties.setPassword(password);

    if (poolProperties.getDataSourceJNDI() != null && poolProperties.getDataSource() == null) {
      performJNDILookup(context, poolProperties);
    }
    if (XA) {
      XADataSource ds = new XADataSource(poolProperties);
      ds.createPool();
      return ds;
    } else {
      org.apache.tomcat.jdbc.pool.DataSource ds = new org.apache.tomcat.jdbc.pool.DataSource(poolProperties);
      ds.createPool();
      return ds;
    }
  }

  /**
   * decrypt password using user input.
   */
  private String decryptByPrompt(String keyName, String encodedPwd) {
    int i = 0;
    boolean correctSecret = false;
    String decoded = null;
    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    System.out.print("What is the " + keyName + ":");
    while (i < 3 && !correctSecret) {
      String secretKey = null;
      try {
        secretKey = br.readLine();
        if (null == secretKey) {
          System.out.print("What is the " + keyName + " key:");
        } else {
          decoded = new Encryptor(secretKey).decrypt(encodedPwd);
          correctSecret = true;
        }
      } catch (Throwable e) {
        System.out.print("Incorrect key(" + secretKey + "),try again:");
      }
      i += 1;
    }
    if (null == decoded) throw new RuntimeException("Cannot decoded " + encodedPwd);
    return decoded;
  }

  private Properties parse(String string) throws Exception {
    ScriptEngineManager sem = new ScriptEngineManager();
    ScriptEngine engine = sem.getEngineByName("javascript");
    Properties result = new Properties();
    @SuppressWarnings({ "unchecked", "rawtypes" })
    Iterator<Map.Entry<?, Object>> iter = ((Map) (engine.eval("result =" + string))).entrySet().iterator();
    while (iter.hasNext()) {
      Map.Entry<?, Object> one = iter.next();
      String value = null;
      if (one.getValue() instanceof Double) {
        Double d = (Double) one.getValue();
        if (java.lang.Double.compare(d, d.intValue()) > 0) value = d.toString();
        else value = String.valueOf(d.intValue());
      } else {
        value = one.getValue().toString();
      }

      String key = (one.getKey().toString() == "maxActive") ? "maxTotal" : one.getKey().toString();
      result.put(key, value);
    }
    return result;
  }

  private String getResponseText(URL constructedUrl) {
    HttpURLConnection conn = null;
    try {
      conn = (HttpURLConnection) constructedUrl.openConnection();
      BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
      String line = in.readLine();
      StringBuffer stringBuffer = new StringBuffer(255);
      while (line != null) {
        stringBuffer.append(line);
        stringBuffer.append("\n");
        line = in.readLine();
      }
      return stringBuffer.toString();
    } catch (Exception e) {
      throw new RuntimeException(e);
    } finally {
      if (conn != null) conn.disconnect();
    }
  }
}
