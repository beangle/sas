#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`
java -cp "$SERVER_HOME/bin/lib/*" org.beangle.as.config.shell.Config $SERVER_HOME
