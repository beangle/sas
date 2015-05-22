#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export TARGET="$1"

stop_server()
{
  export CATALINA_SERVER="$1"
  export CATALINA_BASE="$SERVER_HOME"/servers/"$CATALINA_SERVER"
  echo "Using CONFIG:          $CATALINA_BASE/server.xml"
  exec "$TOMCAT_HOME"/bin/catalina.sh stop -config "$CATALINA_BASE"/server.xml
}

if [ "$TARGET" = "" ]; then
  echo "Usage:stop.sh server_name"
  exit
fi

shopt -s nullglob
if [ -d servers ]; then
  cd $SERVER_HOME/servers
  for dir in * ; do
    if [ "$dir" = "$TARGET" ]; then
        stop_server $dir
    elif [ "${dir%.*}" = "$TARGET" ]; then
        stop_server $dir
    fi
  done
else
  echo "Cannot find any server."
  exit 1
fi
