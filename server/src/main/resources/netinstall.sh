#!/bin/sh

beangle_tomcat_version="0.2.7-SNAPSHOT"
if [ "$1" != "" ]; then
  beangle_tomcat_version="$1"
fi

if [ ! -f beangle-tomcat-server-$beangle_tomcat_version.zip ]; then
  wget "http://repo1.maven.org/maven2/org/beangle/tomcat/beangle-tomcat-server/$beangle_tomcat_version/beangle-tomcat-server-$beangle_tomcat_version.zip"
fi

if [ -f beangle-tomcat-server-$beangle_tomcat_version.zip ]; then
  export BEANGLE_SERVER="beangle-tomcat-server-$beangle_tomcat_version"
  unzip -q $BEANGLE_SERVER.zip

  cd $BEANGLE_SERVER
  chmod a+x bin/*.sh
  bin/init.sh
  bin/install.sh tomcat 8.0.36
fi