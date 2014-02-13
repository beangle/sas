#!/bin/sh
PRG="$0"
PRGDIR=`dirname "$PRG"`
EXECUTABLE=catalina.sh
export CATALINA_OUT=`cd "$PRGDIR/.." >/dev/null; pwd`/logs/"$1".out
echo Using config :conf/"$1".xml
echo Using CATALINA_OUT:"$CATALINA_OUT"
exec "$PRGDIR"/"$EXECUTABLE" stop -config conf/"$1".xml
