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

  # link lib
  ln -sf  ../../tomcat/lib

  # link conf
  cd conf
  local config_files=("catalina.policy" "catalina.properties" "context.xml" "logging.properties" "tomcat-users.xml" "web.xml")
  for cfg_file in "${config_files[@]}" ; do
    if [ -e "../../../conf/$cfg_file" ]; then
      ln -sf ../../../conf/$cfg_file
    else
      ln -sf ../../../tomcat/conf/$cfg_file
    fi
  done

  if [ "$2" = "run" ]; then
    exec "$TOMCAT_HOME"/bin/catalina.sh run
  else
    exec "$TOMCAT_HOME"/bin/catalina.sh start
  fi
}

if [ "$1" = "" ]; then
  echo "Usage:start-server.sh server_name"
  exit
fi

if [ "$2" = "" ]; then
  echo "Usage:start-server.sh server_name start/run"
  exit
fi

start_server $1 $2
