#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export CATALINA_SERVER="$1"
export CATALINA_BASE=$SERVER_HOME/servers/$CATALINA_SERVER

echo "Using CONFIG:          $CATALINA_BASE/bin/server.xml"
exec "$TOMCAT_HOME"/bin/catalina.sh stop -config $CATALINA_BASE/bin/server.xml
