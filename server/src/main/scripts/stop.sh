#!/bin/sh
PRGDIR=`dirname "$0"`
SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TARGET="$1"

if [ "$TARGET" = "" ]; then
  echo "Usage:stop.sh server_name or farm_name"
  exit
fi

cd $SAS_HOME

shopt -s nullglob
if [ -d servers ]; then
  cd $SAS_HOME/servers
  stopped=0
  for dir in * ; do
    if [ "$dir" = "$TARGET" ] || [ "${dir%.*}" = "$TARGET" ] || [ "all" = "$TARGET" ]; then
      stopped=$((stopped+1))
      $SAS_HOME/bin/catalina.sh stop $dir
    fi
  done

  if [ $stopped == 0 ];then
    echo "Cannot find server with name $TARGET"
  elif (( stopped > 1 )); then
    echo "$stopped servers stopped."
  fi
else
  echo "Cannot find any server."
  exit 1
fi
