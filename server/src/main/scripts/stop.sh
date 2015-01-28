#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TARGET="$1"
cd $SERVER_HOME/servers

for dir in $(command ls -1d *); do
    if [ "$dir" = "$TARGET" ]; then
        echo $dir
        $SERVER_HOME/bin/stop-server.sh $dir
    elif [ "${dir%.*}" = "$TARGET" ]; then
        $SERVER_HOME/bin/stop-server.sh $dir
    fi
done

