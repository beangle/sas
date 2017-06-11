package org.beangle.sas.http.web.handler

import java.io.{ File, FileInputStream }

import org.beangle.commons.activation.MimeTypeProvider
import org.beangle.commons.lang.{ Strings, SystemInfo }
import org.beangle.commons.lang.annotation.spi
import org.beangle.commons.web.io.DefaultWagon
import org.beangle.commons.web.util.RequestUtils
import org.beangle.webmvc.api.annotation.action
import org.beangle.webmvc.api.util.CacheControl
import org.beangle.webmvc.execution.Handler

import javax.servlet.http.{ HttpServletRequest, HttpServletResponse }

object ResouceHander {
  def homeDir: String = {
    var resourceHome = System.getProperty("DOC_BASE");
    if (null == resourceHome) SystemInfo.user.home + "/resources" else resourceHome
  }
}

class ResourceHandler extends Handler {

  val wagon = new DefaultWagon

  val expireMinutes = 60 * 24 * 7

  def handle(request: HttpServletRequest, response: HttpServletResponse): Any = {
    val path = RequestUtils.getServletPath(request)
    find(path) match {
      case Some(f) =>
        val ext = Strings.substringAfterLast(path, ".")
        if (Strings.isNotEmpty(ext)) MimeTypeProvider.getMimeType(ext) foreach (m => response.setContentType(m.toString))
        if (etagChanged(String.valueOf(f.lastModified), request, response)) {
          CacheControl.expiresAfter(expireMinutes, response)
          response.setDateHeader("Last-Modified", f.lastModified)
          wagon.copy(new FileInputStream(f), request, response)
          response.setStatus(HttpServletResponse.SC_OK)
        }
      case None => response.setStatus(HttpServletResponse.SC_NOT_FOUND)
    }
  }

  /**
   * return true if etag changed
   */
  private def etagChanged(etag: String, request: HttpServletRequest, response: HttpServletResponse): Boolean = {
    val requestETag = request.getHeader("If-None-Match")
    // not modified, content is not sent - only basic headers and status SC_NOT_MODIFIED
    val changed = !etag.equals(requestETag)
    if (!changed) response.setStatus(HttpServletResponse.SC_NOT_MODIFIED)
    else response.setHeader("ETag", etag)
    changed
  }

  private def find(path: String): Option[File] = {
    val f = new File(ResouceHander.homeDir + path)
    if (f.exists && f.isFile()) Some(f)
    else None
  }

}
