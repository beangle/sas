#!/bin/sh
PRGDIR=`dirname "$0"`

export TOMCAT_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

if [ "$1" == "" ]; then
    echo "Usage: update.sh version"
    echo "Example: update.sh 8.0.14"
    exit
fi
export TOMCAT_VERSION="$1"

cd $PRGDIR/..

read -p "Are you update tomcat to $TOMCAT_VERSION(Y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    source $(dirname $0)/create-tomcat.sh
fi
