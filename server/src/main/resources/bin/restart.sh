#!/bin/bash
PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
export sas_restart="1"
args="$@"
. "$SAS_HOME/bin/start.sh"  $args
