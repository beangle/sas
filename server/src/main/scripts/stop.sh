#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export TARGET="$1"

if [ "$TARGET" = "" ]; then
  echo "Usage:stop.sh server_name or farm_name"
  exit
fi

shopt -s nullglob
if [ -d servers ]; then
  cd $SERVER_HOME/servers
  stopped=0
  for dir in * ; do
    stopped=$((stopped+1))
    if [ "$dir" = "$TARGET" ]; then
      $SERVER_HOME/bin/stop-server.sh $dir
    elif [ "${dir%.*}" = "$TARGET" ]; then
      $SERVER_HOME/bin/stop-server.sh $dir
    else
      stopped=$((stopped-1))
    fi
  done

  if [ $stopped == 0 ];then
    echo "Cannot find server with name $TARGET"
  elif (( stopped > 1 )); then
    echo "$stopped servers stopped."
  else
    echo "One server stopped."
  fi
else
  echo "Cannot find any server."
  exit 1
fi
