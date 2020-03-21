/*
 * Beangle, Agile Development Scaffold and Toolkits.
 *
 * Copyright © 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.shell

import java.io.{File, FileInputStream, FileOutputStream}
import java.net.URL

import org.beangle.commons.io.IOs
import org.beangle.commons.lang.Strings.{isEmpty, isNotEmpty, split, substringAfterLast}
import org.beangle.repo.artifact.{Artifact, ArtifactDownloader, BeangleResolver, Repo}
import org.beangle.sas.model.Container

object Resolver {

  def main(args: Array[String]): Unit = {
    if (args.length < 1) {
      println("Usage: Resolve /path/to/server.xml")
      return
    }
    val configFile = new File(args(0))
    val container = Container(scala.xml.XML.load(new FileInputStream(configFile)))
    val sasHome = configFile.getParentFile.getParentFile.getCanonicalPath

    val repository = container.repository
    val remote =
      if (repository.remote.isEmpty) new Repo.Remote("remote", Repo.Remote.AliyunURL)
      else new Repo.Remote("remote", repository.remote.get)

    val local = new Repo.Local(repository.local.orNull)
    resolve(sasHome, container, remote, local)
  }

  def resolve(sasHome: String, container: Container, remote: Repo.Remote, local: Repo.Local): Unit = {
    container.webapps foreach { webapp =>
      if (isEmpty(webapp.docBase)) {
        if (isNotEmpty(webapp.url)) {
          val fileName = download(webapp.url, sasHome + "/webapps/")
          webapp.docBase = sasHome + "/webapps/" + fileName
        } else if (isNotEmpty(webapp.gav)) {
          val gavinfo = split(webapp.gav, ":")
          if (gavinfo.length < 3) throw new RuntimeException(s"Invalid gav ${webapp.gav},Using groupId:artifactId:version format.")
          val old = Artifact(webapp.gav)
          val war = Artifact(old.groupId, old.artifactId, old.version, old.classifier, "war")
          new ArtifactDownloader(remote, local).download(List(war))
          webapp.docBase = local.url(war)
        } else {
          throw new RuntimeException(s"Invalid Webapp definition ${webapp.name},one of (docBase,url,gav) properties needed.")
        }
      } else {
        if (webapp.docBase.contains("${sas.home}")) {
          webapp.docBase = webapp.docBase.replace("${sas.home}", sasHome)
        } else if (webapp.docBase.startsWith("../../..")) {
          webapp.docBase = webapp.docBase.replace("../../..", sasHome)
        }
      }

      //解析轻量级war
      if (new File(webapp.docBase).exists()) {
        val libs = BeangleResolver.resolve(webapp.docBase)
        new ArtifactDownloader(remote, local).download(libs)
        val missing = libs filter (!local.exists(_))
        if (missing.nonEmpty) {
          System.err.println("Download error :" + missing)
          System.err.println("Cannot launch webapp :" + webapp.docBase)
        }
      }
    }
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
