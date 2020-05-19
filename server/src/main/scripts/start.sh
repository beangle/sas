#!/bin/sh
PRGDIR=`dirname "$0"`
export SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`

if [ ! -d $SAS_HOME/bin/lib ]; then
  echo "Please init beangle sas server first."
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage:start.sh server_name or farm_name"
  exit
fi

# start servername
start(){
  export SERVER_NAME="$1"
  export SERVER_BASE="$SAS_HOME"/servers/$SERVER_NAME
  export SERVER_PID="$SERVER_BASE"/SERVER_PID
  export SERVER_OUT="$SERVER_BASE"/logs/console.out
  export SERVER_TMPDIR="$SERVER_BASE"/temp

  if [ -s "$SERVER_PID" ]; then
      PID=`cat "$SERVER_PID"`
      ps -p $PID >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        ps  --no-headers -f -p $PID
        echo "$SERVER_NAME appears to still be running with PID $PID. Start aborted."
        return 1
      else
        rm -f "$SERVER_PID" >/dev/null 2>&1
        if [ $? != 0 ]; then
          cat /dev/null > "$SERVER_PID"
        fi
      fi
  else
    rm -f "$SERVER_PID" >/dev/null 2>&1
  fi

  java -cp "$SAS_HOME/lib/*:$SAS_HOME/bin/lib/*" org.beangle.sas.shell.Maker $SAS_HOME/conf/server.xml $SERVER_NAME

  if [ -r "$SERVER_BASE/bin/setenv.sh" ]; then
    . "$SERVER_BASE/bin/setenv.sh"
  fi

  touch "$SERVER_OUT"
  if [ -f $dir/bin/bootstrap.jar ]; then
    export beangle_sas_ver=0.7.5
    export slf4j_ver=2.0.0-alpha1
    export logback_ver=1.3.0-alpha5

    LOGGING_CONFIG="-Dnop"
    LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"

    CLASSPATH=
    CLASSPATH="$SERVER_BASE"/bin/bootstrap.jar
    CLASSPATH="$CLASSPATH":"$SAS_HOME"/bin/lib/beangle-sas-juli-"$beangle_sas_ver".jar

    if [ -z "$JSSE_OPTS" ] ; then
      JSSE_OPTS="-Djdk.tls.ephemeralDHKeySize=2048"
    fi
    SERVER_OPTS="$SERVER_OPTS $JSSE_OPTS"

    # Register custom URL handlers
    # Do this here so custom URL handles (specifically 'war:...') can be used in the security policy
    SERVER_OPTS="$SERVER_OPTS -Djava.protocol.handler.pkgs=org.apache.catalina.webresources"

      eval "java" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $SERVER_OPTS \
        -classpath "\"$CLASSPATH\"" \
        -Dcatalina.base="\"$SERVER_BASE\"" \
        -Dcatalina.home="\"$SERVER_BASE\"" \
        -Dsas.home="\"$SAS_HOME\"" \
        -Dsas.server="\"$SERVER_NAME\"" \
        -Djava.io.tmpdir="\"$SERVER_TMPDIR\"" \
        org.apache.catalina.startup.Bootstrap start \
        >> "$SERVER_OUT" 2>&1 "&"

  elif [ -f "$SERVER_BASE/bin/command.txt" ] ; then
    COMMAND=`cat "$SERVER_BASE/bin/command.txt"`
    eval "$COMMAND"  "$SERVER_BASE/conf/server.xml"  "$SERVER_OPTS" >> "$SERVER_OUT" 2>&1 "&"
  else
    echo "Unrecognize engine,launch is aborted."
    return 1
  fi

  echo $! > "$SERVER_PID"
  echo "$SERVER_NAME started,see logs/$SERVER_NAME/console.out"
  return 0
}

cd $SAS_HOME

shopt -s nullglob
if [ -d servers ]; then
  cd $SAS_HOME/servers
  started=0
  for dir in *; do
    for target in "$@"; do
      if [ "$dir" = "$target" ] ||  [ "all" = "$target" ] || [ "${dir%.*}" = "$target" ]; then
        if start $dir; then
          started=$((started+1))
        fi
      fi
    done
  done

  echo "$started servers started."
else
  echo "Cannot find any server."
  exit 1
fi
