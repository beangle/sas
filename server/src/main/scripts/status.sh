#!/bin/sh
PRGDIR=`dirname "$0"`
export SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`

cd $SAS_HOME
started=0

shopt -s nullglob
if [ -d servers ]; then
  cd $SAS_HOME/servers

  for dir in * ; do
    if [ -f $dir/SERVER_PID ]; then
      PID=`cat "$dir/SERVER_PID"`
      ps -p $PID >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        echo "$dir(pid=$PID) is running."
        started=$((started+1))
      fi
    fi
  done

  if [ $started == 0 ];then
    echo "Beangle Sas is shutdown."
  elif (( started > 1 )); then
    echo "Beangle Sas launches $started servers."
  fi
else
  echo "Cannot find any server."
  exit 1
fi
