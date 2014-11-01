#!/bin/sh
PRGDIR=`dirname "$0"`

export TOMCAT_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

if [ -d tomcat ]; then
    echo "Tomcat already installed."
    exec tomcat/bin/version.sh
    exit
fi

if [ "$1" == "" ]; then
    echo "Usage: install.sh version"
    echo "Example: install.sh 8.0.14"
    exit
fi
export TOMCAT_VERSION="$1"

cd $PRGDIR/..

source $(dirname $0)/create-tomcat.sh

