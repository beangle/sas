package org.beangle.tomcat.jdbc;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Properties;

import javax.naming.Context;
import javax.sql.DataSource;

import org.apache.tomcat.jdbc.pool.DataSourceFactory;
import org.apache.tomcat.jdbc.pool.PoolConfiguration;
import org.apache.tomcat.jdbc.pool.XADataSource;

/**
 * Encrypted DataSourceFactory
 * 
 * @author chaostone
 * @see http://www.idesign4all.nl/blog/?p=103
 */
public class EncryptedDataSourceFactory extends DataSourceFactory {

  public static final String SecretEnvName = "data_source_secret";

  @Override
  public DataSource createDataSource(Properties properties, Context context, boolean XA) throws Exception {
    PoolConfiguration poolProperties = EncryptedDataSourceFactory.parsePoolProperties(properties);
    String password = poolProperties.getPassword();
    String secretKey = null;
    if (password.startsWith("?")) {
      password = password.substring(1);
      secretKey = System.getenv(SecretEnvName);
      if (null == secretKey) password = decryptByPrompt(password);
      else password = new Encryptor(secretKey).decrypt(password);
    } else {
      password = new Encryptor(secretKey).decrypt(password);
    }
    poolProperties.setPassword(password);

    // The rest of the code is copied from Tomcat's DataSourceFactory.
    if (poolProperties.getDataSourceJNDI() != null && poolProperties.getDataSource() == null) {
      performJNDILookup(context, poolProperties);
    }
    org.apache.tomcat.jdbc.pool.DataSource dataSource = XA ? new XADataSource(poolProperties)
        : new org.apache.tomcat.jdbc.pool.DataSource(poolProperties);
    dataSource.createPool();

    return dataSource;
  }

  /**
   * decrypt password using user input.
   * 
   * @param password
   * @return
   */
  private String decryptByPrompt(String password) {
    int i = 0;
    boolean correctSecret = false;
    System.out.print("What is the data_source_secret key:");
    while (i < 3 && !correctSecret) {
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
      String secretKey = null;
      try {
        secretKey = br.readLine();
        if (null == secretKey) break;
        password = new Encryptor(secretKey).decrypt(password);
        correctSecret = true;
      } catch (Exception e) {
        System.out.print("Incorrect key(" + secretKey + "),try again:");
      }
      i++;
    }
    return password;
  }
}
