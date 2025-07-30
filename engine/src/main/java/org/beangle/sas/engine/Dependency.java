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

package org.beangle.sas.engine;

import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;

public class Dependency {
  public static final String DependenciesFile = "META-INF/beangle/dependencies";
  public static final String OldDependenciesFile = "META-INF/beangle/container.dependencies";

  public static class Resolver {
    /**
     * 将两组工件进行合并，相同名称的以第一个集合出现的为准。
     *
     * @param first
     * @param second
     * @return
     */
    public static List<Artifact> merge(List<Artifact> first, List<Artifact> second) {
      if (second.isEmpty()) {
        return first;
      } else if (first.isEmpty()) {
        return second;
      } else {
        var keys = new HashSet<String>();
        List<Artifact> results = new ArrayList<>();
        results.addAll(first);
        for (Artifact a : first) {
          var key = a.groupId + ":" + a.artifactId;
          keys.add(key);
        }
        for (Artifact a : second) {
          var key = a.groupId + ":" + a.artifactId;
          if (!keys.contains(key)) {
            keys.add(key);
            results.add(a);
          }
        }
        return results;
      }
    }

    public static List<Artifact> parse(String gavs) {
      List<Artifact> artifacts = new ArrayList<Artifact>();
      if (null == gavs || gavs.isBlank()) return artifacts;
      var newGavs = gavs.replace(';', ',');
      newGavs = newGavs.replaceAll("\n", ",");
      newGavs = newGavs.replaceAll("\r", "");
      newGavs = newGavs.replaceAll(",,", ",");
      var gavArray = newGavs.trim().split(",");
      for (String line : gavArray) {
        artifacts.add(new Artifact(line.trim()));
      }
      return artifacts;
    }

    public static List<Artifact> resolve(URL resource) {
      List<Artifact> artifacts = new ArrayList<Artifact>();
      if (null == resource) return Collections.emptyList();
      try {
        InputStreamReader reader = new InputStreamReader(resource.openStream());
        LineNumberReader lr = new LineNumberReader(reader);
        String line = null;
        do {
          line = lr.readLine();
          if (line != null && !line.isEmpty()) {
            artifacts.add(new Artifact(line));
          }
        } while (line != null);
        lr.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return artifacts;
    }
  }

  public static class LocalRepo {

    public final String base;

    public final String snapshotBase;

    public LocalRepo(String base, String snapshotBase) {
      this.base = base;
      this.snapshotBase = snapshotBase;
    }

    public String path(Artifact artifact) {
      if (artifact.version.endsWith("SNAPSHOT")) {
        return snapshotBase + "/" + artifact.artifactId + "-" + artifact.version + "." + artifact.packaging;
      } else {
        return base + "/" + artifact.groupId.replace('.', '/') + "/" + artifact.artifactId + "/"
          + artifact.version + "/" + artifact.artifactId + "-" + artifact.version + "." + artifact.packaging;
      }
    }
  }

  public static class Artifact {

    public final String groupId;
    public final String artifactId;
    public final String version;
    public final String packaging;

    public Artifact(String gav) {
      String[] infos = gav.split(":");
      this.groupId = infos[0];
      this.artifactId = infos[1];
      this.version = infos[2];
      this.packaging = (infos.length > 3) ? infos[3] : "jar";
    }

    public Artifact(String groupId, String artifactId, String version, String packaging) {
      super();
      this.groupId = groupId;
      this.artifactId = artifactId;
      this.version = version;
      this.packaging = packaging;
    }

    @Override
    public String toString() {
      return this.groupId + ":" + this.artifactId + ":" + this.version + "." + this.packaging;
    }
  }
}
