package org.beangle.sas.model

object Nginx {
  def getDefault: Nginx = {
    new Nginx
  }
}

class Nginx extends Proxy {

}
