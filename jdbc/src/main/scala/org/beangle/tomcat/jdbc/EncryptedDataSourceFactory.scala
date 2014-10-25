package org.beangle.tomcat.jdbc

import java.io.BufferedReader
import java.io.InputStreamReader
import java.{ util => ju }
import java.net.{ HttpURLConnection, URL }

import javax.script.ScriptEngineManager
import javax.naming.Context
import javax.sql.DataSource

import org.apache.tomcat.jdbc.pool.DataSourceFactory
import org.apache.tomcat.jdbc.pool.PoolConfiguration
import org.apache.tomcat.jdbc.pool.XADataSource
import scala.language.existentials
/**
 * Encrypted DataSourceFactory
 *
 * @author chaostone
 * @see http://www.idesign4all.nl/blog/?p=103
 */
class EncryptedDataSourceFactory extends DataSourceFactory {

  override def createDataSource(properties: ju.Properties, context: Context, XA: Boolean): DataSource = {
    val url = properties.get("url").asInstanceOf[String]
    if (null != url && url.startsWith("http")) properties.putAll(parse(getResponseText(new URL(url))))

    val poolProperties = DataSourceFactory.parsePoolProperties(properties)
    val encodedPwd = poolProperties.getPassword
    val keyName = poolProperties.getName.replace("/", "_") + "_secret"
    val secretKey = System.getenv(keyName)
    val password =
      if (encodedPwd.startsWith("?")) {
        if (null == secretKey) decryptByPrompt(keyName, encodedPwd.substring(1))
        else new Encryptor(secretKey).decrypt(encodedPwd.substring(1))
      } else {
        new Encryptor(secretKey).decrypt(encodedPwd)
      }
    poolProperties.setPassword(password)

    if (poolProperties.getDataSourceJNDI != null && poolProperties.getDataSource == null) performJNDILookup(context, poolProperties)
    val dataSource = if (XA) new XADataSource(poolProperties) else new org.apache.tomcat.jdbc.pool.DataSource(poolProperties)
    dataSource.createPool()
    dataSource
  }

  /**
   * decrypt password using user input.
   */
  private def decryptByPrompt(keyName: String, encodedPwd: String): String = {
    var i = 0
    var correctSecret = false
    var decoded: String = null
    val br = new BufferedReader(new InputStreamReader(System.in))
    Console.print(s"What is the $keyName:")
    while (i < 3 && !correctSecret) {
      var secretKey: String = null
      try {
        secretKey = br.readLine()
        if (null == secretKey) {
          Console.print(s"What is the $keyName key:")
        } else {
          decoded = new Encryptor(secretKey).decrypt(encodedPwd)
          correctSecret = true
        }
      } catch {
        case e: Throwable => Console.print("Incorrect key(" + secretKey + "),try again:")
      }
      i += 1
    }
    if (null == decoded) throw new RuntimeException(s"Cannot decoded $encodedPwd")
    decoded
  }

  private def parse(string: String): ju.Properties = {
    val sem = new ScriptEngineManager
    val engine = sem.getEngineByName("javascript")
    val result = new ju.Properties
    val iter = engine.eval("result =" + string).asInstanceOf[ju.Map[_, _]].entrySet().iterator()
    while (iter.hasNext) {
      val one = iter.next.asInstanceOf[ju.Map.Entry[_, AnyRef]]
      val value = one.getValue match {
        case d: java.lang.Double =>
          if (java.lang.Double.compare(d, d.intValue) > 0) d.toString
          else String.valueOf(d.intValue)
        case a: Any => a.toString
      }
      result.put(one.getKey.toString, value)
    }
    println(result)
    result
  }

  private def getResponseText(constructedUrl: URL): String = {
    var conn: HttpURLConnection = null
    try {
      conn = constructedUrl.openConnection().asInstanceOf[HttpURLConnection]
      var in: BufferedReader = null
      in = new BufferedReader(new InputStreamReader(conn.getInputStream, "UTF-8"))
      var line: String = in.readLine()
      val stringBuffer = new StringBuffer(255)
      stringBuffer.synchronized {
        while (line != null) {
          stringBuffer.append(line)
          stringBuffer.append("\n")
          line = in.readLine()
        }
        stringBuffer.toString
      }
    } catch {
      case e: Exception => throw new RuntimeException(e)
    } finally {
      if (conn != null) conn.disconnect()
    }
  }
}
