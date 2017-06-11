#!/bin/sh

beangle_sas_version="0.3.0"
if [ "$1" != "" ]; then
  beangle_sas_version="$1"
fi

if [ ! -f beangle-sas-$beangle_sas_version.zip ]; then
  wget "http://repo1.maven.org/maven2/org/beangle/sas/beangle-sas/$beangle_sas_version/beangle-sas-$beangle_sas_version.zip"
fi

if [ -f beangle-sas-$beangle_sas_version.zip ]; then
  export SAS_SERVER="beangle-sas-$beangle_sas_version"
  unzip -q $SAS_SERVER.zip

  cd $SAS_SERVER
  chmod a+x bin/*.sh
  bin/init.sh
fi