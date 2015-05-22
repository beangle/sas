#!/bin/sh
PRGDIR=`dirname "$0"`
export SERVER_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

java -cp "$SERVER_HOME/ext/*:$SERVER_HOME/bin/lib/*" org.beangle.tomcat.jdbc.Encryptor $1
