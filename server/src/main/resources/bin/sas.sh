#!/bin/sh
PRGDIR=`dirname "$0"`

export SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
if [ -r "$SAS_HOME/bin/setenv.sh" ]; then
  . "$SAS_HOME/bin/setenv.sh"
fi
if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

sas_classpath="$SAS_HOME/bin/lib/*"
sas_command="$1"

if [ "$sas_command" = "version" ] ; then

  java -cp "$sas_classpath" org.beangle.sas.tool.Version $SAS_HOME

elif [ "$sas_command" = "aes" ] ; then

  if [ "$3" = "" ]; then
    echo "Usage:sas.sh aes key plain|encoded"
    exit
  fi
  java -cp "$sas_classpath" org.beangle.sas.tool.Aes "$2" "$3"

elif [ "$sas_command" = "proxy" ] ; then

  java -cp "$sas_classpath" org.beangle.sas.tool.Proxy $SAS_HOME

elif [ "$sas_command" = "config" ] ; then

  java -cp "$sas_classpath" org.beangle.sas.tool.Config $SAS_HOME

elif [ "$sas_command" = "firewall" ] ; then

  java -cp "$sas_classpath" org.beangle.sas.tool.Firewall $SAS_HOME

elif [ "$sas_command" = "resolve" ] ; then

  java -cp "$sas_classpath" org.beangle.sas.tool.Resolver $SAS_HOME/conf/server.xml

elif [ "$sas_command" = "status" ] ; then

  cd $SAS_HOME||exit
  java -cp "$sas_classpath" org.beangle.sas.tool.Version $SAS_HOME
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
  fi
  if [ $started = 0 ];then
    echo "Beangle Sas is shutdown."
  elif (( started > 1 )); then
    echo "Beangle Sas launches $started servers."
  fi

elif [ "$sas_command" = "update" ] ; then
  beangle_sas_version="$2"
  if [ "$2" = "" ]; then
    echo "Usage:sas.sh update new_version"
    exit
  fi
  zip_dir=~/.m2/repository/org/beangle/sas/beangle-sas/$beangle_sas_version
  zip_file=$zip_dir/beangle-sas-$beangle_sas_version.zip
  mkdir -p $zip_dir

  if [ ! -f $zip_file ]; then
    cd $zip_dir||exit
    if wget "$M2_REMOTE_REPO/org/beangle/sas/beangle-sas/$beangle_sas_version/beangle-sas-$beangle_sas_version.zip" 2>/dev/null; then
        echo "fetching $M2_REMOTE_REPO/org/beangle/sas/beangle-sas/$beangle_sas_version/beangle-sas-$beangle_sas_version.zip"
      else
        echo "$beangle_sas_version.zip download error,update aborted."
        exit 1
      fi
  fi

  cd $SAS_HOME||exit

  if [ -f $zip_file ]; then
    export SAS_SERVER="beangle-sas-$beangle_sas_version"
    rm -rf $SAS_HOME/tmp
    unzip -q $zip_file -d $SAS_HOME/tmp
    if [ -d $SAS_HOME/tmp/$SAS_SERVER ]; then
      echo "Stoping all server..."
      $SAS_HOME/bin/stop.sh all

      echo "Replace files ..."
      if [ -f "$SAS_HOME/bin/setenv.sh" ]; then
        cp $SAS_HOME/bin/setenv.sh $SAS_HOME/tmp/$SAS_SERVER/bin/
      fi
      rm -rf $SAS_HOME/bin
      rm -rf $SAS_HOME/engines

      cp -r $SAS_HOME/tmp/$SAS_SERVER/bin $SAS_HOME/bin
      rm -rf $SAS_HOME/tmp
      cd $SAS_HOME
      chmod a+x bin/*.sh
      bin/init.sh
    fi
  fi

else
  echo "Usage: sas.sh ( commands ... )"
  echo "commands:"
  echo "  aes             Generate password by aes"
  echo "  config          Config sas on command line"
  echo "  firewall        Generate firewall config file"
  echo "  proxy           Generate haproxy/enginx config file"
  echo "  status          Show status"
  echo "  update          Update sas to new_version"
  echo "  version         Show version"
  exit 1

fi
