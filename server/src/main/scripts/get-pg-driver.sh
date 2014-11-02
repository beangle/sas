#!/bin/sh

PG_VERSION="9.3-1102-jdbc4"

if [ "$1" != "" ]; then
    PG_VERSION="$1"
fi

PRGDIR=`dirname "$0"`
export LIB_HOME=`cd "$PRGDIR" >/dev/null; pwd`
cd $LIB_HOME

if [ ! -f lib/postgresql-$PG_VERSION.jar ]; then
    ./get-lib.sh org.postgresql postgresql $PG_VERSION
fi
