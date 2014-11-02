#!/bin/sh
PRGDIR=`dirname "$0"`

export TOMCAT_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

cd $PRGDIR/..

if [ -d tomcat ]; then
    echo "Tomcat already installed."
    exec tomcat/bin/version.sh
    exit
fi

if [ -d tomcat ]; then
    export TOMCAT_VERSION=`cat conf/version.txt`
    exec tomcat/bin/version.sh
    exit
fi

if [ "$TOMCAT_VERSION" == "" ]; then
    if [ -f conf/version.txt ]; then
        export TOMCAT_VERSION=`cat conf/version.txt`
    else
        echo "Usage: install.sh version"
        echo "Example: install.sh 8.0.14"
        exit
    fi
else
    export TOMCAT_VERSION="$1"
fi

source $(dirname $0)/create-tomcat.sh

