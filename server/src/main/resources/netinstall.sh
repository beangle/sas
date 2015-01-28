#!/bin/sh

if [ "$1" == "" ]; then
    echo "Usage: netinstall.sh version"
    echo "Example: netinstall.sh 0.1.1"
    exit
fi

export BEANGLE_SERVER_VERSION="$1"

wget "http://repo1.maven.org/maven2/org/beangle/tomcat/beangle-tomcat-server/$BEANGLE_SERVER_VERSION/beangle-tomcat-server-$BEANGLE_SERVER_VERSION.zip"
export BEANGLE_SERVER="beangle-tomcat-server-$BEANGLE_SERVER_VERSION"
unzip -q $BEANGLE_SERVER.zip

cd  $BEANGLE_SERVER
bin/init.sh
