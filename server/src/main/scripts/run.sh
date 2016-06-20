#!/bin/sh
PRGDIR=`dirname "$0"`
export SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
if [ -d $SERVER_HOME/tomcat ]; then
  export TOMCAT_HOME="$SERVER_HOME/tomcat"
else
  echo "Cannot find tomcat,Please install it first."
  exit 1
fi
export TARGET="$1"

if [ ! -d $SERVER_HOME/bin/lib ]; then
  echo "Please init beangle tomcat server first."
  exit 1
fi

java -cp "$SERVER_HOME/lib/*:$SERVER_HOME/bin/lib/*" org.beangle.tomcat.configer.shell.Gen $SERVER_HOME/conf/server.xml $TARGET $SERVER_HOME

shopt -s nullglob
if [ -d servers ]; then
  cd $SERVER_HOME/servers
  started=0
  for dir in *; do
    if [ "$dir" = "$TARGET" ] ||  [ "all" = "$TARGET" ] || [ "${dir%.*}" = "$TARGET" ]; then
      $SERVER_HOME/bin/start-server.sh $dir "run"
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
