/*
 * Copyright (C) 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.beangle.sas.tool

import org.beangle.boot.artifact.{Archive, Artifact, ArtifactDownloader, Repo}
import org.beangle.boot.dependency.AppResolver
import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Strings.substringAfterLast
import org.beangle.sas.config.{ArchiveURI, Container, Webapp}

import java.io.{File, FileInputStream, FileOutputStream}
import java.net.URL
import scala.collection.mutable

/**
 * 解析下载war包中的依赖。
 * 可以单独运行也可以调用
 */
object Resolver {

  def main(args: Array[String]): Unit = {
    if (args.length < 1) {
      println("Usage: Resolve /path/to/server.xml")
      return -1
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    val sasHome = configFile.getParentFile.getParentFile.getCanonicalPath

    val repository = container.repository
    val remote =
      if (repository.remote.isEmpty) new Repo.Remote("remote", Repo.Remote.AliyunURL)
      else new Repo.Remote("remote", repository.remote.get)

    val local = new Repo.Local(repository.local.orNull)
    val missing = resolve(sasHome, remote, local, container.webapps)
    System.exit(if missing.nonEmpty then -1 else 0)
  }

  def resolve(sasHome: String, remote: Repo.Remote, local: Repo.Local, webapps: collection.Seq[Webapp]): collection.Seq[String] = {
    val missings = new mutable.ArrayBuffer[String]
    webapps foreach { webapp =>
      //1. download and translate gav/url to docBase
      if (ArchiveURI.isGav(webapp.uri)) {
        var gav = ArchiveURI.toArtifact(webapp.uri)
        if (gav.packaging == "jar") {
          gav = Artifact(gav.groupId, gav.artifactId, gav.version, gav.classifier, "war")
        }
        new ArtifactDownloader(remote, local, true).download(List(gav))
        webapp.docBase = local.url(gav)
      } else if (ArchiveURI.isRemote(webapp.uri)) {
        val fileName = download(webapp.uri, sasHome + "/webapps/")
        webapp.docBase = sasHome + "/webapps/" + fileName
      } else {
        var docBase = webapp.uri
        if (docBase.contains("${sas.home}")) {
          docBase = docBase.replace("${sas.home}", sasHome)
        } else if (docBase.startsWith("../../..")) {
          docBase = docBase.replace("../../..", sasHome)
        }
        webapp.docBase = docBase
      }

      //2.resolve war
      if new File(webapp.docBase).exists() then
        if webapp.resolveSupport && resolvable(webapp.docBase) then
          val result = AppResolver.process(new File(webapp.docBase), remote, local)
          if result._2.nonEmpty then
            println("Missing:" + result._2.mkString(","))
            println("Cannot launch webapp:" + webapp.docBase)
            missings ++= result._2.map(_.toString)
          end if
        end if
      else
        missings += webapp.docBase
        println(s"""Missing ${webapp.docBase}""")
    }
    missings
  }

  private def resolvable(path: String): Boolean = {
    path.endsWith(".jar") || path.endsWith(".war") || new File(path).isDirectory
  }

  private def download(url: String, dir: String): String = {
    val fileName = substringAfterLast(url, "/")
    val destFile = new File(dir + fileName)
    if (!destFile.exists) {
      val destOs = new FileOutputStream(destFile)
      val warurl = new URL(url)
      IOs.copy(warurl.openStream(), destOs)
      destOs.close()
    }
    fileName
  }
}
