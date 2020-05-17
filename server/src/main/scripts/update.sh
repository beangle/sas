#!/bin/sh
PRGDIR=`dirname "$0"`
SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`

beangle_sas_version="0.7.3"
if [ "$1" == "" ]; then
  echo "Usage: update.sh which_version"
  exit 1;
fi

beangle_sas_version="$1"

zip_dir=~/.m2/repository/org/beangle/sas/beangle-sas/$beangle_sas_version
zip_path=$zip_dir/beangle-sas-$beangle_sas_version.zip
mkdir -p $zip_dir

if [ ! -f $zip_path ]; then
  wget  -O $zip_path "https://repo1.maven.org/maven2/org/beangle/sas/beangle-sas/$beangle_sas_version/beangle-sas-$beangle_sas_version.zip"
fi

if [ -f $zip_path ]; then
  export SAS_SERVER="beangle-sas-$beangle_sas_version"
  rm -rf $SAS_HOME/tmp
  unzip -q $zip_path -d $SAS_HOME/tmp

  echo "Stoping all server..."
  $SAS_HOME/bin/stop.sh all

  rm -rf $SAS_HOME/bin
  rm -rf $SAS_HOME/engines

  echo "Replace files ..."
  cp -r $SAS_HOME/tmp/$SAS_SERVER/bin $SAS_HOME/bin
  rm -rf $SAS_HOME/tmp
  cd $SAS_HOME
  chmod a+x bin/*.sh
  bin/init.sh
fi
