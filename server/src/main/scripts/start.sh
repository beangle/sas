#!/bin/sh
PRGDIR=`dirname "$0"`
export SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
export TARGET="$1"

if [ ! -d $SAS_HOME/bin/lib ]; then
  echo "Please init beangle sas server first."
  exit 1
fi

cd $SAS_HOME

java -cp "$SAS_HOME/lib/*:$SAS_HOME/bin/lib/*" org.beangle.sas.shell.Maker $SAS_HOME/conf/server.xml $TARGET

shopt -s nullglob
if [ -d servers ]; then
  cd $SAS_HOME/servers
  started=0
  for dir in *; do
    if [ "$dir" = "$TARGET" ] ||  [ "all" = "$TARGET" ] || [ "${dir%.*}" = "$TARGET" ]; then
      if [ -f $dir/bin/bootstrap.jar ]; then
        $SAS_HOME/bin/engine/catalina.sh start $dir
      else
        $SAS_HOME/bin/engine/vibed.sh start $dir
      fi
      started=$((started+1))
    fi
  done
  if [ $started == 0 ];then
    echo "Cannot find server with name $TARGET"
  elif (( started > 1 )); then
    echo "$started servers started."
  fi
else
  echo "Cannot find any server."
  exit 1
fi
