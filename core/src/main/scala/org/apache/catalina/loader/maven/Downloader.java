package org.apache.catalina.loader.maven;

import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicLong;

public class Downloader {

  private int threads = 20;
  private int step = 20 * 1024;

  private ExecutorService executor = Executors.newFixedThreadPool(threads);

  protected final String id;
  protected final String url;
  protected final String location;
  protected DownloadStatus status = null;

  public Downloader(String id, String url, String location) {
    super();
    this.id = id;
    this.url = url;
    this.location = location;
  }

  public long getContentLength() {
    return (null == status) ? 0 : status.total;
  }

  public long getDownloaded() {
    return (null == status) ? 0 : status.count.get();
  }

  public String getId() {
    return id;
  }

  public String getUrl() {
    return url;
  }

  public String getLocation() {
    return location;
  }

  public void start() throws IOException {
    File file = new File(location);
    if (file.exists()) { return; }
    URL resourceURL = new URL(url);
    String urlStatus = touchUrl(resourceURL);
    if (null != urlStatus) {
      System.out.print("\r" + urlStatus + " " + url);
      return;
    }
    file.getParentFile().mkdirs();
    downloading();
  }

  /**
   * 访问资源状态
   * 
   * @param url
   * @return null表示可以访问，其他的表示不能访问的原因
   */
  protected String touchUrl(URL url) {
    HttpURLConnection headConnection;
    try {
      headConnection = (HttpURLConnection) url.openConnection();
      headConnection.setRequestMethod("HEAD");
      headConnection.setDoOutput(true);
      int statusCode = headConnection.getResponseCode();
      switch (statusCode) {
      case HttpURLConnection.HTTP_OK:
        return null;
      case HttpURLConnection.HTTP_FORBIDDEN:
        return "Access denied!";
      case HttpURLConnection.HTTP_NOT_FOUND:
        return "Not Found";
      case HttpURLConnection.HTTP_UNAUTHORIZED:
        return "Access denied";
      default:
        return String.valueOf(statusCode);
      }
    } catch (IOException e) {
      return "Error transferring file: " + e.getMessage();
    }
  }

  protected void close(Closeable... objs) {
    for (Closeable obj : objs) {
      try {
        if (obj != null) obj.close();
      } catch (Exception e) {
      }
    }
  }

  protected void finish(long elaps) {
    if (elaps == 0)
      System.out.print("\r" + getId() + " " + this.getUrl() + " " + (status.total / 1024) + "KB");
    else System.out.print("\r" + getId() + " " + this.getUrl() + " " + (status.total / 1024) + "KB("
        + ((int) (status.total / 1024.0 / elaps * 100000.0) / 100.0) + "KB/s)");
    System.out.println();
  }

  protected void downloading() throws IOException {
    System.out.println("Downloading " + url);
    final URL resourceURL = new URL(url);
    URLConnection conn = resourceURL.openConnection();
    long startAt = System.currentTimeMillis();
    this.status = new DownloadStatus(conn.getContentLength());
    int total = (int) this.status.total;
    if (total > Integer.MAX_VALUE || total <= 0)
      throw new RuntimeException("File size :[" + total + "] not suitable for using DefaultURLDownloader");

    final byte[] totalbuffer = new byte[total];
    int begin = 0;
    List<Callable<Integer>> tasks = new ArrayList<Callable<Integer>>();
    while (begin < this.status.total) {
      final int start = begin;
      final int end = ((start + step - 1) > total) ? total : (start + step - 1);
      tasks.add(new Callable<Integer>() {
        public Integer call() throws Exception {
          HttpURLConnection connection = (HttpURLConnection) resourceURL.openConnection();
          connection.setRequestProperty("RANGE", "bytes=" + start + "-" + end);
          InputStream input = connection.getInputStream();
          byte[] buffer = new byte[1024];
          int n = input.read(buffer);
          int next = start;

          while (-1 != n) {
            System.arraycopy(buffer, 0, totalbuffer, next, n);
            status.count.addAndGet(n);
            next += n;
            n = input.read(buffer);
          }
          close(input);
          return end;
        }
      });
      begin += step;
    }
    try {
      executor.invokeAll(tasks);
      executor.shutdown();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }

    if (status.count.get() == status.total) {
      OutputStream output = new FileOutputStream(new File(location));
      output.write(totalbuffer, 0, total);
      close(output);
    } else {
      throw new RuntimeException("Download error");
    }
    finish(System.currentTimeMillis() - startAt);
  }

  class DownloadStatus {
    public final int total;
    public final AtomicLong count = new AtomicLong(0);

    public DownloadStatus(int total) {
      super();
      this.total = total;
    }
  }

}
