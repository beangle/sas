#!/bin/sh

BEANGLE_SERVER_VERSION="0.2.5"
if [ "$1" != "" ]; then
    BEANGLE_SERVER_VERSION="$1"
fi

wget "http://repo1.maven.org/maven2/org/beangle/tomcat/beangle-tomcat-server/$BEANGLE_SERVER_VERSION/beangle-tomcat-server-$BEANGLE_SERVER_VERSION.zip"
export BEANGLE_SERVER="beangle-tomcat-server-$BEANGLE_SERVER_VERSION"
unzip -q $BEANGLE_SERVER.zip

cd  $BEANGLE_SERVER
chmod a+x bin/*.sh
bin/init.sh
bin/install.sh tomcat 8.0.36