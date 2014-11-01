#!/bin/sh

PRGDIR=`dirname "$0"`
if [ "$1" == "" ]; then
    echo "Usage: get-scala.sh version"
    echo "Example: get-scala.sh 2.11.2"
    exit
fi

export EXT_HOME=`cd "$PRGDIR" >/dev/null; pwd`
cd $EXT_HOME

if [ ! -f ext/scala-library-$1.jar ]; then
    ./get-ext.sh org.scala-lang scala-library $1
fi

if [ ! -f ext/scala-reflect-$1.jar ]; then
    ./get-ext.sh org.scala-lang scala-reflect $1
fi

if [ "$1" == "2.11.2" ] && [ ! -f ext/scala-xml_2.11-1.0.2.jar ]; then
    ./get-ext.sh org.scala-lang.modules scala-xml_2.11 1.0.2
fi
