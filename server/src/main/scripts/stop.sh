#!/bin/sh
PRGDIR=`dirname "$0"`
HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export CATALINA_SERVER="$1"
export CATALINA_BASE=$HOME/servers/$CATALINA_SERVER

echo "Using CONFIG:          $CATALINA_BASE/bin/server.xml"
exec "$TOMCAT_HOME"/bin/catalina.sh stop -config $CATALINA_BASE/bin/server.xml
