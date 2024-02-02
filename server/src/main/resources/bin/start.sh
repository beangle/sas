#!/bin/bash
PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
. "$SAS_HOME/bin/env.sh"

if [ $# -eq 0 ]; then
  echo "Usage:start.sh server_name or farm_name"
  exit
fi

if [ ! -d $SAS_HOME/bin/lib ]; then
  . "$SAS_HOME/bin/init.sh"
fi

if [ -f "$SAS_HOME/bin/setenv.sh" ]; then
  if [ ! -x "$SAS_HOME/bin/setenv.sh" ]; then
    chmod +x "$SAS_HOME/bin/setenv.sh"
  fi
  . "$SAS_HOME/bin/setenv.sh"
fi

if [ $sas_remote_url ] && [ "$sas_remote_connect" != "offline" ]; then
  echo -n "fetching $sas_remote_url/config/server.xml..."
  mkdir -p $SAS_HOME/conf/
  ip_addresses=$(hostname -I)
  wget -q $sas_remote_url/config/server.xml --header="ip:$ip_addresses" -O $SAS_HOME/conf/server_newer.xml || rm $SAS_HOME/conf/server_newer.xml
  if [ -f $SAS_HOME/conf/server_newer.xml ]; then
    rm -rf $SAS_HOME/conf/server_old.xml
    if [ -f $SAS_HOME/conf/server.xml ]; then
      mv $SAS_HOME/conf/server.xml $SAS_HOME/conf/server_old.xml
    fi
    mv $SAS_HOME/conf/server_newer.xml $SAS_HOME/conf/server.xml
    echo "ok"
  else
    echo "cannot get server.xml,startup was aborted."
    exit 1;
  fi
fi

if [ ! -f $SAS_HOME/conf/server.xml ]; then
  echo "Missing conf/server.xml,startup was aborted."
  exit 1
fi

if [ -z "$sas_restart" ]; then
  export sas_restart="0"
fi

stop(){
  SERVER_NAME="$1"
  SERVER_BASE="$SAS_HOME"/servers/$SERVER_NAME
  SERVER_PID="$SERVER_BASE"/SERVER_PID

  SLEEP=5
  FORCE=1

  if [  -s "$SERVER_PID" ]; then
    PID=$(cat "$SERVER_PID")
    kill -15 $PID >/dev/null 2>&1
  else
    return 1
  fi

  while [ $SLEEP -ge 0 ]; do
    kill -0 $PID >/dev/null 2>&1
    if [ $? -gt 0 ]; then
      rm -f "$SERVER_PID" >/dev/null 2>&1
      FORCE=0
      echo "$SERVER_NAME stopped."
      break
    fi
    if [ $SLEEP -gt 0 ]; then
      sleep 1
    fi
    SLEEP=$(expr $SLEEP - 1 )
  done

  if [ $FORCE -eq 1 ]; then
      echo "$SERVER_NAME stopped(killing $PID)"
      kill -9 $PID
  fi
  rm -f "$SERVER_PID"
  return 0
}

# start servername
start(){
  export SERVER_NAME="$1"
  export SERVER_BASE="$SAS_HOME"/servers/$SERVER_NAME
  export SERVER_PID="$SERVER_BASE"/SERVER_PID
  export SERVER_OUT="$SERVER_BASE"/logs/console.out
  export SERVER_TMPDIR="$SERVER_BASE"/temp

  if [ -s "$SERVER_PID" ]; then
    if [ "$sas_restart" == "1" ]; then
      stop "$1"
    else
      PID=$(cat "$SERVER_PID")
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
    fi
  else
    rm -f "$SERVER_PID" >/dev/null 2>&1
  fi

  if [ -r "$SERVER_BASE/bin/setenv.sh" ]; then
    . "$SERVER_BASE/bin/setenv.sh"
  fi

  touch "$SERVER_OUT"
  if [ -f $dir/bin/bootstrap.jar ]; then

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
    COMMAND=$(cat "$SERVER_BASE/bin/command.txt")
    eval "$COMMAND" --server "$SERVER_BASE/conf/server.xml"  "$SERVER_OPTS" >> "$SERVER_OUT" 2>&1 "&"
  else
    echo "Unrecognized engine,launch is aborted."
    return 1
  fi

  echo $! > "$SERVER_PID"
  echo "$SERVER_NAME started,see logs/$SERVER_NAME/console.out"
  return 0
}

cd $SAS_HOME

shopt -s nullglob

mkdir -p $SAS_HOME/servers
cd $SAS_HOME/servers

for target in "$@"; do
  java -cp "$SAS_HOME/lib/*:$SAS_HOME/bin/lib/*" org.beangle.sas.tool.Maker $SAS_HOME/conf/server.xml $target
done

started=0
for dir in *; do
  for target in "$@"; do
    if [ "$dir" = "$target" ] ||  [ "all" = "$target" ] || [ "${dir%.*}" = "$target" ]; then
      if [ ! -f "$dir/error" ]; then
        if start $dir; then
          started=$((started+1))
        fi
      else
        echo "see $dir/error"
      fi
    fi
  done
done
echo "$started servers started."
