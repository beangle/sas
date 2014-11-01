#!/bin/sh

PG_VERSION="9.3-1102-jdbc4"

if [ "$1" != "" ]; then
    PG_VERSION="$1"
fi

PRGDIR=`dirname "$0"`
export EXT_HOME=`cd "$PRGDIR" >/dev/null; pwd`
cd $EXT_HOME


if [ ! -f ext/postgresql-$PG_VERSION.jar ]; then
    ./get-ext.sh org.postgresql postgresql $PG_VERSION
fi
