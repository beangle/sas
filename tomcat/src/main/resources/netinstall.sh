#!/bin/sh

beangle_as_version="0.2.7"
if [ "$1" != "" ]; then
  beangle_as_version="$1"
fi

if [ ! -f beangle-as-tomcat-$beangle_as_version.zip ]; then
  wget "http://repo1.maven.org/maven2/org/beangle/as/beangle-as-tomcat/$beangle_as_version/beangle-as-tomcat-$beangle_as_version.zip"
fi

if [ -f beangle-as-tomcat-$beangle_as_version.zip ]; then
  export BEANGLE_SERVER="beangle-as-tomcat-$beangle_as_version"
  unzip -q $BEANGLE_SERVER.zip

  cd $BEANGLE_SERVER
  chmod a+x bin/*.sh
  bin/init.sh
  bin/install.sh tomcat 8.0.43
fi