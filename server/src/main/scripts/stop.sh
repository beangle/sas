#!/bin/sh
PRGDIR=`dirname "$0"`
SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export SAS_HOME

if [ $# -eq 0 ]; then
  echo "Usage:stop.sh server_name or farm_name"
  exit
fi

stop(){
  SERVER_NAME="$1"
  SERVER_BASE="$SAS_HOME"/servers/$SERVER_NAME
  SERVER_PID="$SERVER_BASE"/SERVER_PID

  SLEEP=5
  FORCE=1

  if [  -s "$SERVER_PID" ]; then
    PID=`cat "$SERVER_PID"`
    kill -15 $PID >/dev/null 2>&1
  else
    return 1
  fi

  while [ $SLEEP -ge 0 ]; do
    kill -0 $PID >/dev/null 2>&1
    if [ $? -gt 0 ]; then
      rm -f "$SERVER_PID" >/dev/null 2>&1
      FORCE=0
      echo "$SERVER_NAME stopped."
      break
    fi
    if [ $SLEEP -gt 0 ]; then
      sleep 1
    fi
    SLEEP=`expr $SLEEP - 1 `
  done

  if [ $FORCE -eq 1 ]; then
      echo "$SERVER_NAME stopped(killing $PID)"
      kill -9 $PID
  fi
  rm -f "$SERVER_PID"
  return 0
}

cd $SAS_HOME

shopt -s nullglob
if [ -d servers ]; then
  cd $SAS_HOME/servers
  stopped=0
  for dir in * ; do
    for target in "$@"; do
      if [ "$dir" = "$target" ] || [ "${dir%.*}" = "$target" ] || [ "all" = "$target" ]; then
        if  stop $dir; then
          stopped=$((stopped+1))
        fi
      fi
    done
  done

  echo "$stopped servers stopped."
else
  echo "Cannot find any server."
  exit 1
fi
