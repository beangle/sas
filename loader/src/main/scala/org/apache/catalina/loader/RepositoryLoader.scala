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

class RepositoryLoader(parent: ClassLoader) extends WebappLoader(parent) {

  val dependenciesFile = "META-INF/container.dependencies"
  var url = "http://central.maven.org/maven2"
  var layout = "maven2"
  var cacheBase: String = _
  var remote: RemoteRepository = _
  var local: LocalRepository = _
  def this() {
    this(null)
  }

  override def startInternal() {
    if (null == cacheBase) {
      cacheBase = layout match {
        case "maven2" => System.getProperties().getProperty("user.home") + "/.m2/repository"
        case "ivy2" => System.getProperties().getProperty("user.home") + "/.ivy2/cache"
        case _ => throw new RuntimeException("Do not support layout $layout,Using maven2 or ivy2")
      }
    }
    log("Loading jars from:" + cacheBase)
    remote = new RemoteRepository(url)
    local = new LocalRepository(cacheBase, layout)

    super.startInternal()
    val cl = super.getClassLoader() match {
      case devCl: WebappClassLoader =>
        val sb = new StringBuilder("Added:")
        readWebClassPathEntries() foreach { url =>
          val file = new File(url)
          sb ++= file.getName
          sb ++= "  "
          devCl.addURL(file.toURI.toURL)
        }
        log(sb.toString)
      case _ => logError("Unable to install WebappClassLoader !")
    }
  }

  private def log(msg: String) {
    println((new StringBuilder("[RepositoryLoader] ")).append(msg).toString())
  }

  private def logError(msg: String) {
    Console.err.println((new StringBuilder("[RepositoryLoader] Error: ")).append(msg).toString())
  }

  private def readWebClassPathEntries(): List[String] = {
    val cpFile = super.getClassLoader().getResource(dependenciesFile)
    val rc = new ListBuffer[String]
    if (null != cpFile) {
      try {
        val reader = new InputStreamReader(cpFile.openStream())
        val lr = new LineNumberReader(reader)
        val artifacts = new ListBuffer[Artifact]
        var line: String = null
        do {
          line = lr.readLine()
          if (line != null && !line.isEmpty) {
            val infos = line.split(":")
            artifacts += new Artifact(infos(0), infos(1), infos(2))
          }
        } while (line != null)
        lr.close()

        rc ++= artifacts.map(a => local.path(a))
        downloadJars(artifacts.filter(a => !new File(local.path(a)).exists))
      } catch {
        case ioEx: IOException => ioEx.printStackTrace()
      }
    } else {
      logError(s"Cannot find $dependenciesFile")
    }
    rc.toList
  }

  private def downloadJars(artifacts: ListBuffer[Artifact]): Unit = {
    if (artifacts.isEmpty) return
    val splash = Array('\\', '|', '/', '-')
    val threads = new ListBuffer[Downloader]()
    var i = 0
    while (artifacts.size > 0 || threads.size > 0) {
      print("\b" * 100)
      if (threads.size < 4 && artifacts.size > 0) {
        val artifact = artifacts.remove(0)
        val fileName = s"${artifact.artifactId}-${artifact.version}.jar"
        val pair = (remote.url(artifact), local.path(artifact))
        println("download:" + pair._1)
        val thread = new Downloader(threads, pair)
        thread.start()
        threads += thread
      } else {
        Thread.sleep(500)
      }
      val sb = new StringBuilder()
      sb += splash(i % 4)
      sb ++= "  "
      threads.foreach(t => sb ++= (t.count / 1024 + "KB/" + (t.fileSize / 1024) + "KB    "))
      sb ++= (" " * (100 - sb.length))
      i += 1
      print(sb.toString)
    }
    print("\n")
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
        file.getParentFile().mkdirs()
        val buffer = new Array[Byte](1024 * 4)
        val conn = url.openConnection()
        fileSize = conn.getContentLength()
        val input = url.openConnection().getInputStream
        val output = new FileOutputStream(file)
        var n = input.read(buffer)
        while (eof != n) {
          output.write(buffer, 0, n)
          count += n
          n = input.read(buffer)
        }
        file.renameTo(new File(pair._2))
      } finally {
        if (input != null) input.close()
        if (output != null) output.close()
        threads -= this
      }
    }
  }

  def setUrl(url: String): Unit = {
    this.url = url
  }

  def setLayout(layout: String): Unit = {
    this.layout = layout
  }

  def setCacheBase(cacheBase: String): Unit = {
    this.cacheBase = cacheBase
  }
}