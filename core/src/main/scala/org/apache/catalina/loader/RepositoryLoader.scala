package org.apache.catalina.loader

import java.io.{ File, FileOutputStream, IOException, InputStream, InputStreamReader, LineNumberReader, OutputStream }
import java.net.URL
import scala.collection.mutable.ListBuffer
import org.beangle.maven.launcher.{ Artifact, LocalRepository, RemoteRepository }
import org.beangle.maven.launcher.DependencyResolver
import org.beangle.maven.launcher.CustomDependencyResolver
import org.beangle.maven.launcher.ArtifactDownloader

class RepositoryLoader(parent: ClassLoader) extends WebappLoader(parent) {

  val resolver: DependencyResolver = new CustomDependencyResolver();
  var url: String = _
  var cacheLayout = "maven2"
  var cacheBase: String = _
  var remote: RemoteRepository = _
  var local: LocalRepository = _

  def this() {
    this(null)
  }

  override def startInternal() {
    log("Loading jars from:" + cacheBase)
    remote = if (null == url) new RemoteRepository() else new RemoteRepository(url)
    local = new LocalRepository(cacheBase, cacheLayout)

    super.startInternal()
    val cl = super.getClassLoader() match {
      case devCl: WebappClassLoader =>
        val sb = new StringBuilder("Add Class Path:")
        val artifacts = resolver.resolve(super.getClassLoader().getResource(CustomDependencyResolver.DependenciesFile))
        new ArtifactDownloader(remote, local).download(artifacts)
        artifacts foreach { artifact =>
          val file = new File(local.path(artifact))
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

  def setUrl(url: String): Unit = {
    this.url = url
  }

  def setCacheLayout(cacheLayout: String): Unit = {
    this.cacheLayout = cacheLayout
  }

  def setCacheBase(cacheBase: String): Unit = {
    this.cacheBase = cacheBase
  }
}