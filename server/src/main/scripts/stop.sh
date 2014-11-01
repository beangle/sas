#!/bin/sh
PRGDIR=`dirname "$0"`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export CATALINA_SERVER="$1"
export CATALINA_BASE="$TOMCAT_HOME"/../servers/"$CATALINA_SERVER"

echo "Using CONFIG:          conf/$CATALINA_SERVER.xml"
exec "$TOMCAT_HOME"/bin/catalina.sh stop -config "$TOMCAT_HOME"/conf/"$CATALINA_SERVER".xml
