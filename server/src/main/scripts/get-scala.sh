#!/bin/sh

if [ "$1" == "" ]; then
    echo "Usage: get-scala.sh version"
    echo "Example: get-scala.sh 2.11.2"
    exit
fi

PRGDIR=`dirname "$0"`
export LIB_HOME=`cd "$PRGDIR" >/dev/null; pwd`
cd $LIB_HOME

if [ ! -f lib/scala-library-$1.jar ]; then
    ./get-lib.sh org.scala-lang scala-library $1
fi

if [ ! -f lib/scala-reflect-$1.jar ]; then
    ./get-lib.sh org.scala-lang scala-reflect $1
fi

if [ "$1" == "2.11.2" ] && [ ! -f lib/scala-xml_2.11-1.0.2.jar ]; then
    ./get-lib.sh org.scala-lang.modules scala-xml_2.11 1.0.2
fi
