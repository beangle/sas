#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage:
   launch.sh [jvm_options] /path/to/war [--port=8080] [--path=/yourbase] [other_args]
   launch.sh [jvm_options] group_id:artifact_id:version [other_args]
   launch.sh [jvm_options] http://host.com/path/towar [other_args]"
  exit 1
fi

PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
. "$SAS_HOME/bin/env.sh"

# launch classpath
bootpath=""
# full command line to java
opts="$*"
# war file
warfile=""

# download groupId artifactId version
download(){
  group_id=$(echo "$1" | tr . /)
  URL="$M2_REMOTE_REPO/$group_id/$2/$3/$2-$3.jar"
  artifact_name="$2-$3.jar"
  local_file="$M2_REPO/$group_id/$2/$3/$2-$3.jar"
  bootpath=$bootpath":"$local_file

  if [ ! -f $local_file ]; then
    if wget --spider $URL 2>/dev/null; then
      echo "fetching $URL"
    else
      echo "$URL not exists,installation aborted."
      exit 1
    fi

    if command -v aria2c >/dev/null 2; then
      aria2c -x 16 $URL
    else
      wget $URL -O $artifact_name.part
      mv $artifact_name.part $artifact_name
    fi
    mkdir -p "$M2_REPO/$group_id/$2/$3"
    mv $artifact_name $local_file
  fi
}

#find warfile in opts
detect_warfile(){
  for arg in $opts
  do
      if [ "$arg" = "${arg#"-"}" ]; then
        warfile="$arg"
        break;
      fi
  done

  # try to find jar file
  if [ -z "$warfile" ]; then
    echo "Cannot find jar file in args,launch was aborted."
    exit
  fi
}

download org.scala-lang scala3-library_3 $scala_ver
download org.scala-lang scala-library $scala_lib_ver
download org.beangle.commons beangle-commons $beangle_commons_ver
download org.apache.commons commons-compress $commons_compress_ver
download org.beangle.boot beangle-boot $beangle_boot_ver
download org.slf4j slf4j-api $slf4j_ver
download ch.qos.logback logback-core $logback_ver
download ch.qos.logback logback-classic $logback_ver

detect_warfile
#get options and args of java program
args="${opts#*$warfile}"
options="${opts%%$warfile*}"
bootpath="${bootpath:1}" #omit head :
#destfile is resolved absolute file path.
destfile=$(java -cp "$bootpath" org.beangle.boot.dependency.AppResolver $warfile --remote=$M2_REMOTE_REPO --local=$M2_REPO --quiet)
if [ $? -ne 0  ]; then
  echo "Cannot resolve $warfile, Launching aborted"
  exit
fi

# reset bootpath
bootpath=""
download org.apache.tomcat.embed tomcat-embed-core $tomcat_ver
download org.apache.tomcat.embed tomcat-embed-jasper $tomcat_ver
download org.apache.tomcat.embed tomcat-embed-websocket $tomcat_ver
download org.beangle.sas beangle-sas-engine $beangle_sas_ver

bootpath="${bootpath:1}" #omit head :
#echo java -server -cp "$bootpath" $options "org.beangle.sas.engine.tomcat.Bootstrap" $args $destfile
java -server -cp "$bootpath" $options "org.beangle.sas.engine.tomcat.Bootstrap" $args $destfile
