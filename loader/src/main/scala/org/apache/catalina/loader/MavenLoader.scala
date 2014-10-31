package org.apache.catalina.loader

import java.io.LineNumberReader
import java.io.FileReader
import java.io.File
import javax.servlet.ServletContext
import org.apache.catalina.Context
import java.net.URL
import java.io.IOException
import scala.collection.mutable.ListBuffer
import java.util.StringTokenizer
import java.io.FileOutputStream
import java.io.InputStream
import scala.xml.Null
import java.io.OutputStream
import java.io.InputStreamReader
import java.io.Reader

class MavenLoader(parent: ClassLoader) extends WebappLoader(parent) {

  var webClassPathFile = "META-INF/webclasspath"
  var repositoryPath = System.getProperties().getProperty("user.home") + "/.mavenLoader"
  if (!new File(repositoryPath).exists()) {
    new File(repositoryPath).mkdirs()
  }

  def this() {
    this(null)
  }

  override def startInternal() {
    log("Starting DevLoader")
    super.startInternal()
    val cl = super.getClassLoader() match {
      case devCl: WebappClassLoader =>
        readWebClassPathEntries() foreach { url =>
          log(url)
          devCl.addURL(new File(url).toURI().toURL())
        }
      case _ => logError("Unable to install WebappClassLoader !")
    }
  }

  protected def log(msg: String) {
    println((new StringBuilder("[MavenLoader] ")).append(msg).toString())
  }

  protected def logError(msg: String) {
    Console.err.println((new StringBuilder("[MavenLoader] Error: ")).append(msg).toString())
  }

  protected def readWebClassPathEntries(): List[String] = {
    val cpFile = super.getClassLoader().getResource(webClassPathFile)
    val rc = new ListBuffer[String]
    if (null != cpFile) {
      var reader: Reader = null
      try {
        reader = new InputStreamReader(cpFile.openStream())
        val lr = new LineNumberReader(reader)
        var line: String = null
        do {
          line = lr.readLine()
          if (line != null) {
            val infos = line.split(":")
            rc += s"${repositoryPath}/${infos(0)}/${infos(1)}-${infos(2)}.jar"
          }
        } while (line != null)
        downloadJars(rc.toList)
        rc.toList
      } catch {
        case ioEx: IOException => ioEx.printStackTrace()
      }
    } else {
      logError(s"Cannot find $webClassPathFile")
    }
    rc.toList
  }

  private def downloadJars(urls: List[String]) {
    val downloadList = new ListBuffer[Tuple2[String, String]]()
    urls.foreach(url => {
      val file = new File(url)
      if (!file.exists()) {
        val name = file.getName()
        val version = name.substring(name.lastIndexOf("-") + 1).replace(".jar", "")
        val artifact = name.substring(0, name.lastIndexOf("-"))
        //http://central.maven.org/maven2/junit/junit/4.11/junit-4.11.jar
        val pair = (s"http://central.maven.org/maven2/${file.getParentFile().getName.replace(".", "/")}/$artifact/$version/$name", url.toString())
        downloadList += pair
      }
    })
    val splash = Array('\\', '|', '/', '-')
    val threads = new ListBuffer[Downloader]()
    var i = 0
    while (downloadList.size > 0 || threads.size > 0) {
      print("\b" * 100)
      if (threads.size < 4 && downloadList.size > 0) {
        val pair = downloadList.remove(0)
        println("download:" + pair._1)
        val thread = new Downloader(threads, pair)
        thread.start()
        threads += thread
      } else {
        Thread.sleep(1000)
      }
      val sb = new StringBuilder()
      sb += splash(i % 4)
      sb ++= "  "
      threads.foreach(t => sb ++= (t.count / 1024 + "KB/" + (t.fileSize / 1024) + "KB    "))
      sb ++= (" " * (100 - sb.length))
      i += 1
      print(sb.toString)
    }
  }

  class Downloader(threads: ListBuffer[Downloader], pair: Tuple2[String, String]) extends Thread {
    var fileSize, count = 0
    private val eof = -1
    override def run() {
      var input: InputStream = null
      var output: OutputStream = null
      try {
        val url = new URL(pair._1)
        val file = new File(pair._2 + ".part")
        val buffer = new Array[Byte](1024 * 4)
        val conn = url.openConnection()
        fileSize = conn.getContentLength()
        val input = url.openConnection().getInputStream()
        if (!file.getParentFile().exists()) {
          file.getParentFile().mkdirs()
        }
        val output = new FileOutputStream(file)
        var n = input.read(buffer)
        while (eof != n) {
          output.write(buffer, 0, n)
          count += n
          n = input.read(buffer)
        }
        file.renameTo(new File(pair._2))
      } catch {
        case t: Throwable =>
          t.printStackTrace()
          if (input != null) input.close()
          if (output != null) output.close()
      }
      threads -= this
    }
  }
}