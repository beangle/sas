#!/bin/sh
PRGDIR=`dirname "$0"`
SAS_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

export key="$1"
export data="$2"

if [ "$data" = "" ]; then
  echo "Usage:aes.sh key plain|encoded"
  exit
fi

java -cp "$SAS_HOME/bin/lib/*" org.beangle.sas.shell.Aes $key $data
