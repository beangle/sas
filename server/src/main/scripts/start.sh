#!/bin/sh
PRGDIR=`dirname "$0"`
export SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export TARGET="$1"

java -cp "$SERVER_HOME/ext/*:$SERVER_HOME/bin/lib/*" org.beangle.tomcat.configurer.shell.Gen $SERVER_HOME/conf/config.xml $TARGET $SERVER_HOME

start_server()
{

  CATALINA_SERVER="$1"
  export CATALINA_BASE=$SERVER_HOME/servers/$CATALINA_SERVER
  echo "Using CONFIG:          $CATALINA_BASE/server.xml"

  cd $SERVER_HOME
  mkdir -p $CATALINA_BASE/webapps
  mkdir -p $CATALINA_BASE/temp
  mkdir -p $CATALINA_BASE/work
  mkdir -p $CATALINA_BASE/logs

  touch $CATALINA_BASE/logs/catalina.out
  #remove unzipped context
  rm -rf $CATALINA_BASE/webapps/*
  cd $CATALINA_BASE
  ln -sf  ../../tomcat/lib
  ln -sf  ../../tomcat/conf

  exec "$TOMCAT_HOME"/bin/catalina.sh start -config $CATALINA_BASE/server.xml
}

shopt -s nullglob
if [ -d servers ]; then
  cd $SERVER_HOME/servers
  started=0
  for dir in *; do
    if [ "$dir" = "$TARGET" ]; then
      start_server $dir
      started++
    elif [ "${dir%.*}" = "$TARGET" ]; then
      start_server $dir
      started++
    fi
  done
  if [ $started == 0 ];then
    echo "Cannot find any server"
  fi
else
  echo "Cannot find any server."
  exit 1
fi
