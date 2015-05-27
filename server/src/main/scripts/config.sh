#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`
java -cp "$SERVER_HOME/bin/lib/*" org.beangle.tomcat.configer.shell.Config $SERVER_HOME
