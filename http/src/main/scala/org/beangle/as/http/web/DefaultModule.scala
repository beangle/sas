package org.beangle.as.http.web

import org.beangle.commons.cdi.bind.BindModule

class DefaultModule extends BindModule {

  override def binding() {
    bind(classOf[RouteConfig])
  }
}
