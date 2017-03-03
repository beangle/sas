package org.beangle.as.http.web

import org.beangle.commons.cdi.bind.AbstractBindModule

class DefaultModule extends AbstractBindModule {

  override def binding() {
    bind(classOf[RouteConfig])
  }
}
