#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`


stop_server()
{
  export CATALINA_SERVER="$1"
  export CATALINA_BASE="$SERVER_HOME"/servers/"$CATALINA_SERVER"
  echo "Using CONFIG:          $CATALINA_BASE/server.xml"
  exec "$TOMCAT_HOME"/bin/catalina.sh stop -config "$CATALINA_BASE"/server.xml
}

if [ "$1" = "" ]; then
  echo "Usage:stop-server.sh server_name"
  exit
fi

stop_server $1
