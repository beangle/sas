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

package org.beangle.sas.config

import org.beangle.boot.artifact.{Repo, Repos}

case class Repository(local: Option[String], remote: Option[String]) {
  def toRelease: Repos.Release = {
    var remoteUrl = if (this.remote.isEmpty) Repo.Remote.AliyunURL else this.remote.get
    if !remoteUrl.contains(Repo.Remote.CentralURL) then remoteUrl += "," + Repo.Remote.CentralURL
    val remotes = Repo.remotes(remoteUrl)
    val local = new Repo.Local(this.local.orNull)
    Repos.Release(local, remotes)
  }
}

case class SnapshotRepo(local: Option[String], remote: Option[String]) {
  def toSnapshot: Repos.Snapshot = {
    val remote = if (this.remote.isEmpty) null else Repo.remote(this.remote.get)
    val local = Repo.LocalSnapshot(this.local.orNull)
    Repos.Snapshot(local, remote)
  }
}
