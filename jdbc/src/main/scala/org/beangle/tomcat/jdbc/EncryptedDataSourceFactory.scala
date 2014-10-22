package org.beangle.tomcat.jdbc

import java.io.BufferedReader
import java.io.InputStreamReader
import java.{ util => ju }

import javax.naming.Context
import javax.sql.DataSource

import org.apache.tomcat.jdbc.pool.DataSourceFactory
import org.apache.tomcat.jdbc.pool.PoolConfiguration
import org.apache.tomcat.jdbc.pool.XADataSource

/**
 * Encrypted DataSourceFactory
 *
 * @author chaostone
 * @see http://www.idesign4all.nl/blog/?p=103
 */
class EncryptedDataSourceFactory extends DataSourceFactory {

  override def createDataSource(properties: ju.Properties, context: Context, XA: Boolean): DataSource = {
    val poolProperties = DataSourceFactory.parsePoolProperties(properties)
    val encodedPassword = poolProperties.getPassword()
    val name = poolProperties.getName
    val secretKey: String = System.getenv(name.replace("/", "_") + "_secret")
    val password =
      if (encodedPassword.startsWith("?")) {
        if (null == secretKey) decryptByPrompt(encodedPassword.substring(1))
        else new Encryptor(secretKey).decrypt(encodedPassword.substring(1))
      } else {
        new Encryptor(secretKey).decrypt(encodedPassword)
      }
    poolProperties.setPassword(password)
    // The rest of the code is copied from Tomcat's DataSourceFactory.
    if (poolProperties.getDataSourceJNDI != null && poolProperties.getDataSource == null) performJNDILookup(context, poolProperties)
    val dataSource = if (XA) new XADataSource(poolProperties) else new org.apache.tomcat.jdbc.pool.DataSource(poolProperties)
    dataSource.createPool()
    dataSource
  }

  /**
   * decrypt password using user input.
   */
  private def decryptByPrompt(password: String): String = {
    var i = 0
    var correctSecret = false
    var decoded: String = null
    val br = new BufferedReader(new InputStreamReader(System.in))
    Console.print("What is the data_source_secret key:")
    while (i < 3 && !correctSecret) {
      var secretKey: String = null
      try {
        secretKey = br.readLine()
        if (null == secretKey) {
          Console.print("What is the data_source_secret key:")
        } else {
          decoded = new Encryptor(secretKey).decrypt(password)
          correctSecret = true
        }
      } catch {
        case e: Throwable => Console.print("Incorrect key(" + secretKey + "),try again:")
      }
      i += 1
    }
    if (null == decoded) throw new RuntimeException("Cannot decoded " + password)
    decoded
  }
}
