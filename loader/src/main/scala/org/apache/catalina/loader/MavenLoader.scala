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

class MavenLoader(parent: ClassLoader) extends WebappLoader(parent) {

  var webClassPathFile = "WEB-INF/webclasspath"
  var tomcatPluginFile = ".tomcatplugin"
  var repositoryPath = System.getProperties().getProperty("user.home") + "/.m2/repository/"
  if (!new File(repositoryPath).exists()) {
    new File(repositoryPath).mkdirs()
  }

  def this() {
    this(null)
  }

  override def startInternal() {
    log("Starting DevLoader")
    super.startInternal()
    val cl = super.getClassLoader()
    if (!(cl.isInstanceOf[WebappClassLoader])) {
      logError("Unable to install WebappClassLoader !")
    } else {
      val devCl = cl.asInstanceOf[WebappClassLoader]
      val classpath = new StringBuffer()
      readWebClassPathEntries() foreach { url =>
        log(url)
        devCl.addURL(new File(url).toURL())
      }
    }
  }

  protected def log(msg: String) {
    println((new StringBuilder("[MavenLoader] ")).append(msg).toString())
  }

  protected def logError(msg: String) {
    System.err.println((new StringBuilder("[MavenLoader] Error: ")).append(msg).toString())
  }

  protected def readWebClassPathEntries(): List[String] = {
    val prjDir = new File(servletContext.getRealPath("/"))
    val urls = loadWebClassPathFile(prjDir)
    downloadJars(urls)
    urls
  }

  protected def loadWebClassPathFile(prjDir: File): List[String] = {
    val cpFile = new File(prjDir, this.webClassPathFile)
    if (cpFile.exists()) {
      var reader: FileReader = null
      try {
        val rc = new ListBuffer[String]()
        reader = new FileReader(cpFile)
        val lr = new LineNumberReader(reader)
        var line: String = null
        do {
          line = lr.readLine()
          if (line != null) {
            line = line.replace('\\', '/')
            rc += repositoryPath + line
          }
        } while (line != null)
        rc.toList
      } catch {
        case ioEx: IOException =>
          ioEx.printStackTrace()
          null
      }
    } else null
  }

  private def downloadJars(urls: List[String]) {
    val downloadList = new ListBuffer[Tuple2[String, String]]()
    urls.foreach(url => {
      if (!new File(url).exists()) {
        val pair = ("http://central.maven.org/maven2/" + url.toString().substring(repositoryPath.length()), url.toString())
        downloadList += pair
      }
    })

    val threads = new ListBuffer[Downloader]()
    while (downloadList.size > 0 || threads.size > 0) {
      print("\b" * 1000)
      if (threads.size < 4 && downloadList.size > 0) {
        val pair = downloadList.remove(0)
        println("download:" + pair._1)
        val thread = new Downloader(threads, pair)
        thread.start()
        threads += thread
      } else {
        Thread.sleep(1000)
      }
      threads.foreach(t => print(t.count / 1024 + "KB/" + (t.fileSize / 1024) + "KB    "))
      print(" " * 100)
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
        val file = new File(pair._2 + ".tmp")
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
        case t =>
          t.printStackTrace()
          if (input != null) input.close()
          if (output != null) output.close()
      }
      threads -= this
    }
  }

  protected def servletContext: ServletContext = {
    //tomcat 8.0
    this.getContext.getServletContext
    //tomcat 7.0
    //    getContainer().asInstanceOf[Context].getServletContext()
  }
}