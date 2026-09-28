#!/bin/bash
PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
args="$@"
if ! $SAS_HOME/bin/sas.sh resolve  $args; then
  echo "resolve failed,restart was aborted."
  exit 1
fi
$SAS_HOME/bin/stop.sh  $args
$SAS_HOME/bin/start.sh  $args
