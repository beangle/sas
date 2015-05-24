#!/bin/sh
PRGDIR=`dirname "$0"`
export SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`

start_server()
{

  CATALINA_SERVER="$1"
  export CATALINA_BASE=$SERVER_HOME/servers/$CATALINA_SERVER

  cd $SERVER_HOME
  mkdir -p $CATALINA_BASE/webapps
  mkdir -p $CATALINA_BASE/temp
  mkdir -p $CATALINA_BASE/work
  mkdir -p $CATALINA_BASE/logs
  mkdir -p $CATALINA_BASE/conf

  touch $CATALINA_BASE/logs/catalina.out
  #remove unzipped context
  rm -rf $CATALINA_BASE/webapps/*
  cd $CATALINA_BASE
  ln -sf  ../../tomcat/lib
  cd conf
  ln -sf ../../../conf/catalina.policy
  ln -sf ../../../conf/catalina.properties
  ln -sf ../../../conf/context.xml
  ln -sf ../../../conf/logging.properties
  ln -sf ../../../conf/tomcat-users.xml
  ln -sf ../../../conf/web.xml

  exec "$TOMCAT_HOME"/bin/catalina.sh start
}


if [ "$1" = "" ]; then
  echo "Usage:start-server.sh server_name"
  exit
fi

start_server $1
