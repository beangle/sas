#!/bin/bash
PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
args="$@"
$SAS_HOME/bin/sas.sh resolve  $args
$SAS_HOME/bin/stop.sh  $args
$SAS_HOME/bin/start.sh  $args
