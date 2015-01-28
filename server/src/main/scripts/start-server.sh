#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export CATALINA_SERVER="$1"
export CATALINA_BASE=$SERVER_HOME/servers/$CATALINA_SERVER

echo "Using CONFIG:          $CATALINA_BASE/bin/server.xml"

mkdir -p $CATALINA_BASE/webapps
mkdir -p $CATALINA_BASE/temp
mkdir -p $CATALINA_BASE/work
mkdir -p $CATALINA_BASE/logs
mkdir -p $CATALINA_BASE/bin

touch $CATALINA_BASE/logs/catalina.out
#remove unzipped context
rm -rf $CATALINA_BASE/webapps/*
cd $CATALINA_BASE
ln -sf  ../../tomcat/lib
ln -sf  ../../tomcat/conf

exec "$TOMCAT_HOME"/bin/catalina.sh start -config $CATALINA_BASE/bin/server.xml
