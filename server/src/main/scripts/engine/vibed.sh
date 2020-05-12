#!/bin/sh

PRGDIR=`dirname "$0"`
export SAS_HOME=`cd "$PRGDIR/../../" >/dev/null; pwd`

VIBED_CMD="$1"
VIBED_SERVER="$2"

export VIBED_BASE="$SAS_HOME"/servers/$VIBED_SERVER
export VIBED_HOME=$VIBED_BASE
export SERVER_PID="$VIBED_BASE"/SERVER_PID
export VIBED_OUT="$VIBED_BASE"/logs/console.out
export VIBED_TMPDIR="$VIBED_BASE"/temp

cd $VIBED_BASE


if [ -r "$VIBED_BASE/bin/setenv.sh" ]; then
  . "$VIBED_BASE/bin/setenv.sh"
fi

if [ "$VIBED_CMD" = "start" ] ; then

  if [ -s "$SERVER_PID" ]; then
      PID=`cat "$SERVER_PID"`
      ps -p $PID >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        ps  --no-headers -f -p $PID
        echo "$VIBED_SERVER appears to still be running with PID $PID. Start aborted."
        exit 1
      else
        rm -f "$SERVER_PID" >/dev/null 2>&1
        if [ $? != 0 ]; then
          cat /dev/null > "$SERVER_PID"
        fi
      fi
  else
    rm -f "$SERVER_PID" >/dev/null 2>&1
  fi

  touch "$VIBED_OUT"
  eval "$VIBED_BASE/bin/start"  "$VIBED_BASE/conf/server.xml"  "$VIBED_OPTS" >> "$VIBED_OUT" 2>&1 "&"
  echo $! > "$SERVER_PID"
  echo "$VIBED_SERVER started,see logs/$VIBED_SERVER/console.out"

elif [ "$VIBED_CMD" = "stop" ] ; then

  SLEEP=5
  FORCE=1

  if [  -s "$SERVER_PID" ]; then
    PID=`cat "$SERVER_PID"`
    kill -15 $PID >/dev/null 2>&1
  else
    echo "PID file is empty,Stop aborted."
    exit 1
  fi

  while [ $SLEEP -ge 0 ]; do
    kill -0 $PID >/dev/null 2>&1
    if [ $? -gt 0 ]; then
      rm -f "$SERVER_PID" >/dev/null 2>&1
      FORCE=0
      echo "$VIBED_SERVER stopped."
      break
    fi
    if [ $SLEEP -gt 0 ]; then
      sleep 1
    fi
    SLEEP=`expr $SLEEP - 1 `
  done

  if [ $FORCE -eq 1 ]; then
      echo "Killing $VIBED_SERVER with the PID: $PID"
      kill -9 $PID
  fi
  rm -f "$SERVER_PID"
else

  echo "Usage: vibed.sh ( commands ... )"
  echo "commands:"
  echo "  start             Start VIBED in a separate window"
  echo "  stop              Stop VIBED, waiting up to 5 seconds for the process to end"
  exit 1

fi
