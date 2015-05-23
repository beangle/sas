#!/bin/sh
PRGDIR=`dirname "$0"`
export SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export TARGET="$1"

java -cp "$SERVER_HOME/ext/*:$SERVER_HOME/bin/lib/*" org.beangle.tomcat.configurer.shell.Gen $SERVER_HOME/conf/config.xml $TARGET $SERVER_HOME

shopt -s nullglob
if [ -d servers ]; then
  cd $SERVER_HOME/servers
  started=0
  for dir in *; do
    if [ "$dir" = "$TARGET" ]; then
      $SERVER_HOME/bin/start-server.sh $dir
      started=$((started+1))
    elif [ "${dir%.*}" = "$TARGET" ]; then
      $SERVER_HOME/bin/start-server.sh $dir
      started=$((started+1))
    fi
  done
  if [ $started == 0 ];then
    echo "Cannot find server with name $TARGET"
  elif (( started > 1 )); then
    echo "$started servers started."
  else
    echo "One server started."
  fi
else
  echo "Cannot find any server."
  exit 1
fi
