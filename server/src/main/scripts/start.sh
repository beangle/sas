#!/bin/sh
PRGDIR=`dirname "$0"`
export TOMCAT_HOME=`cd "$PRGDIR/../tomcat/" >/dev/null; pwd`
export CATALINA_SERVER="$1"
export CATALINA_BASE="$TOMCAT_HOME"/../servers/"$CATALINA_SERVER"

echo "Using CONFIG:          conf/$CATALINA_SERVER.xml"

mkdir -p $CATALINA_BASE/webapps
mkdir -p $CATALINA_BASE/temp
mkdir -p $CATALINA_BASE/work
mkdir -p $CATALINA_BASE/logs
touch $CATALINA_BASE/logs/catalina.out
#remove unzipped context
rm -rf $CATALINA_BASE/webapps/*
cd $CATALINA_BASE
ln -sf  ../../tomcat/lib
ln -sf  ../../tomcat/conf

exec "$TOMCAT_HOME"/bin/catalina.sh start -config "$TOMCAT_HOME"/conf/"$CATALINA_SERVER".xml
