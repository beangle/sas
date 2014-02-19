#!/bin/sh
PRG="$0"
PRGDIR=`dirname "$PRG"`
export EAMS_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`
export JAVA_HOME=`cd "$PRGDIR/../jdk" >/dev/null; pwd`
echo Using EAMS_HOME:"$EAMS_HOME"
echo Using JAVA_HOME:"$JAVA_HOME"
$JAVA_HOME/bin/java -cp "$EAMS_HOME/bin/lib/*" org.beangle.tomcat.config.shell.Sql $EAMS_HOME 
