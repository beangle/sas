#!/bin/bash

beangle_sas_version="0.12.5"
if [ "$1" != "" ]; then
  beangle_sas_version="$1"
fi

if [ ! -f beangle-sas-$beangle_sas_version.zip ]; then
  wget "https://repo1.maven.org/maven2/org/beangle/sas/beangle-sas/$beangle_sas_version/beangle-sas-$beangle_sas_version.zip"
fi

if [ -f beangle-sas-$beangle_sas_version.zip ]; then
  export SAS_SERVER="beangle-sas-$beangle_sas_version"
  unzip -u -q $SAS_SERVER.zip
  rm -rf META-INF

  cd $SAS_SERVER
  chmod a+x bin/*.sh
  bin/init.sh
fi
