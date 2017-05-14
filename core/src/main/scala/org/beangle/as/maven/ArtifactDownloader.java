package org.beangle.as.maven;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.beangle.as.util.Delta;

/**
 * ArtifactDownloader
 * <p>
 * Support Features
 * <li>1. Display download processes
 * <li>2. Multiple thread downloading
 * <li>3. Detect resource status before downloading
 * </p>
 * 
 * @author chaostone
 */
public class ArtifactDownloader {

  private final Repository.Remote remote;
  private final Repository.Local local;

  private Map<String, Downloader> statuses = new ConcurrentHashMap<String, Downloader>();

  private ExecutorService executor;

  public ArtifactDownloader(Repository.Remote remote, Repository.Local local) {
    super();
    this.remote = remote;
    this.local = local;
    this.executor = Executors.newFixedThreadPool(5);
  }

  public void download(final List<Artifact> artifacts) {
    List<Artifact> sha1s = new ArrayList<Artifact>(artifacts.size());
    List<Diff> diffs = new ArrayList<Diff>(artifacts.size());

    for (Artifact artifact : artifacts) {
      if (!new File(local.path(artifact)).exists()) {
        Artifact sha1 = artifact.sha1();
        if (!new File(local.path(sha1)).exists()) {
          sha1s.add(sha1);
        }
        Artifact lastest = local.lastest(artifact);
        if (null != lastest) {
          Diff diff = new Diff(lastest, artifact.version);
          diffs.add(diff);
        }
      }
    }
    doDownload(sha1s);

    // download diffs and patch them.
    doDownload(diffs);
    List<Artifact> newers = new ArrayList<Artifact>(artifacts.size());
    for (Diff diff : diffs) {
      String diffLoc = local.path(diff);
      if (new File(diffLoc).exists()) {
        Delta.patch(local.path(diff.older()), local.path(diff.newer()), local.path(diff));
        newers.add(diff.newer());
      }
    }
    // check it,last time.
    for (Artifact artifact : artifacts) {
      if (!new File(local.path(artifact)).exists()) {
        newers.add(artifact);
      }
    }
    doDownload(newers);
    // verify sha1 against newer artifacts.
    for (Artifact artifact : newers) {
      local.verifySha1(artifact);
    }
    executor.shutdown();
  }

  private void doDownload(final List<? extends Product> artifacts) {
    if (artifacts.size() <= 0) return;
    int idx = 1;
    for (final Product artifact : artifacts) {
      if (new File(local.path(artifact)).exists()) continue;

      final int id = idx;
      executor.execute(new Runnable() {
        public void run() {
          Downloader downloader = new Downloader(id + "/" + artifacts.size(), remote.url(artifact), local
              .path(artifact));
          statuses.put(downloader.getUrl(), downloader);
          try {
            downloader.start();
          } catch (IOException e) {
            e.printStackTrace();
          } finally {
            statuses.remove(downloader.getUrl());
          }
        }
      });
      idx += 1;
    }

    sleep(500);
    int i = 0;
    boolean displayProcess = false;
    while (!statuses.isEmpty() && !executor.isTerminated()) {
      sleep(500);
      displayProcess = true;
      char[] splash = new char[] { '\\', '|', '/', '-' };
      // print(multiple("\b", 100));
      print("\r");
      StringBuilder sb = new StringBuilder();
      sb.append(splash[i % 4]).append("  ");
      for (Map.Entry<String, Downloader> thread : statuses.entrySet()) {
        Downloader downloader = thread.getValue();
        sb.append((downloader.getDownloaded() / 1024 + "KB/" + (downloader.getContentLength() / 1024) + "KB    "));
      }
      sb.append((multiple(" ", (100 - sb.length()))));
      i += 1;
      print(sb.toString());
    }
    if (displayProcess) print("\n");
  }

  public static String multiple(String msg, int count) {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < count; i++) {
      sb.append(msg);
    }
    return sb.toString();
  }

  private void sleep(int millsecond) {
    try {
      Thread.sleep(500);
    } catch (InterruptedException e) {
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }

  private static void print(String msg) {
    System.out.print(msg);
  }
}
