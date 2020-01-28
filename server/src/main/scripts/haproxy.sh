#!/bin/sh
PRGDIR=`dirname "$0"`
SAS_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`
java -cp "$SAS_HOME/bin/lib/*" org.beangle.sas.shell.Haproxy $SAS_HOME
