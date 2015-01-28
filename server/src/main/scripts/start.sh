#!/bin/sh
PRGDIR=`dirname "$0"`
SERVER_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TARGET="$1"

java -cp "$SERVER_HOME/bin/ext/*:$SERVER_HOME/bin/lib/*" org.beangle.tomcat.configurer.shell.Gen $SERVER_HOME/conf/config.xml $TARGET $SERVER_HOME

cd $SERVER_HOME/servers

for dir in $(command ls -1d *); do
    if [ "$dir" = "$TARGET" ]; then
        $SERVER_HOME/bin/start-server.sh $dir
    elif [ "${dir%.*}" = "$TARGET" ]; then
        $SERVER_HOME/bin/start-server.sh $dir
    fi
done
