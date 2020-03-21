#!/bin/sh

PRGDIR=`dirname "$0"`
export SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`

CATALINA_CMD="$1"
CATALINA_SERVER="$2"

export CATALINA_BASE="$SAS_HOME"/servers/$CATALINA_SERVER
export CATALINA_HOME=$CATALINA_BASE
export CATALINA_PID="$CATALINA_BASE"/CATALINA_PID
export CATALINA_OUT="$CATALINA_BASE"/logs/console.out
export CATALINA_TMPDIR="$CATALINA_BASE"/temp

export beangle_sas_ver=0.6.6
export slf4j_ver=2.0.0-alpha1
export logback_ver=1.3.0-alpha5

LOGGING_CONFIG="-Dnop"
LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"

CLASSPATH=

if [ -r "$CATALINA_BASE/bin/setenv.sh" ]; then
  . "$CATALINA_BASE/bin/setenv.sh"
elif [ -r "$CATALINA_HOME/bin/setenv.sh" ]; then
  . "$CATALINA_HOME/bin/setenv.sh"
fi

# find java
if [ -z "$JAVA_HOME" ] && [ -z "$JRE_HOME" ]; then
  JAVA_PATH=`which java 2>/dev/null`
  if [ "x$JAVA_PATH" != "x" ]; then
    JAVA_PATH=`dirname "$JAVA_PATH" 2>/dev/null`
    JRE_HOME=`dirname "$JAVA_PATH" 2>/dev/null`
  fi
  if [ -z "$JAVA_HOME" ] && [ -z "$JRE_HOME" ]; then
    echo "Cannot find java"
    exit 1
  fi
fi

if [ -z "$JRE_HOME" ]; then
  JRE_HOME="$JAVA_HOME"
fi

if [ -z "$_RUNJAVA" ]; then
  _RUNJAVA="$JRE_HOME"/bin/java
fi

CLASSPATH="$CATALINA_HOME"/bin/bootstrap.jar
CLASSPATH="$CLASSPATH":"$SAS_HOME"/bin/lib/beangle-sas-juli-"$beangle_sas_ver".jar

if [ -z "$JSSE_OPTS" ] ; then
  JSSE_OPTS="-Djdk.tls.ephemeralDHKeySize=2048"
fi
JAVA_OPTS="$JAVA_OPTS $JSSE_OPTS"

# Register custom URL handlers
# Do this here so custom URL handles (specifically 'war:...') can be used in the security policy
JAVA_OPTS="$JAVA_OPTS -Djava.protocol.handler.pkgs=org.apache.catalina.webresources"

if [ "$CATALINA_CMD" = "start" ] ; then

  if [ -s "$CATALINA_PID" ]; then
      PID=`cat "$CATALINA_PID"`
      ps -p $PID >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        ps  --no-headers -f -p $PID
        echo "$CATALINA_SERVER appears to still be running with PID $PID. Start aborted."
        exit 1
      else
        rm -f "$CATALINA_PID" >/dev/null 2>&1
        if [ $? != 0 ]; then
          cat /dev/null > "$CATALINA_PID"
        fi
      fi
  else
    rm -f "$CATALINA_PID" >/dev/null 2>&1
  fi

  touch "$CATALINA_OUT"
  eval "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
    -classpath "\"$CLASSPATH\"" \
    -Dcatalina.base="\"$CATALINA_BASE\"" \
    -Dcatalina.home="\"$CATALINA_HOME\"" \
    -Dsas.home="\"$SAS_HOME\"" \
    -Dsas.server="\"$CATALINA_SERVER\"" \
    -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
    org.apache.catalina.startup.Bootstrap start \
    >> "$CATALINA_OUT" 2>&1 "&"

  echo $! > "$CATALINA_PID"
  echo "$CATALINA_SERVER started,see logs/$CATALINA_SERVER/console.out"

elif [ "$CATALINA_CMD" = "stop" ] ; then

  SLEEP=5
  FORCE=1

  if [  -s "$CATALINA_PID" ]; then
    PID=`cat "$CATALINA_PID"`
    kill -15 $PID >/dev/null 2>&1
  else
    echo "PID file is empty,Stop aborted."
    exit 1
  fi

  while [ $SLEEP -ge 0 ]; do
    kill -0 $PID >/dev/null 2>&1
    if [ $? -gt 0 ]; then
      rm -f "$CATALINA_PID" >/dev/null 2>&1
      FORCE=0
      echo "$CATALINA_SERVER stopped."
      break
    fi
    if [ $SLEEP -gt 0 ]; then
      sleep 1
    fi
    SLEEP=`expr $SLEEP - 1 `
  done

  if [ $FORCE -eq 1 ]; then
      echo "Killing $CATALINA_SERVER with the PID: $PID"
      kill -9 $PID
  fi
  rm -f "$CATALINA_PID"
else

  echo "Usage: catalina.sh ( commands ... )"
  echo "commands:"
  echo "  start             Start Catalina in a separate window"
  echo "  stop              Stop Catalina, waiting up to 5 seconds for the process to end"
  exit 1

fi

