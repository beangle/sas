#!/bin/sh
PRGDIR=`dirname "$0"`
export SAS_HOME=`cd "$PRGDIR/../" >/dev/null; pwd`
. "$SAS_HOME/bin/env.sh"

cd $PRGDIR
if [ -x "$SAS_HOME/bin/setenv.sh" ]; then
  . "$SAS_HOME/bin/setenv.sh"
fi

if [ ! -f $SAS_HOME/conf/server.xml ] && [ $SAS_ADMIN ] && [ $SAS_PROFILE ]; then
  wget -q $SAS_ADMIN/${SAS_PROFILE}/server.xml -O $SAS_HOME/conf/server.xml
fi

# download groupId artifactId version
download(){
  local group_id=`echo "$1" | tr . /`
  local URL="$M2_REMOTE_REPO/$group_id/$2/$3/$2-$3.jar"
  local artifact_name="$2-$3.jar"
  local local_file="$M2_REPO/$group_id/$2/$3/$2-$3.jar"
  local target="$SAS_HOME/bin/lib"
  mkdir -p $target
  cd $target
  if [ ! -f $artifact_name ]; then
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
      ln -s  $local_file
    else
      ln -s  $local_file
    fi
  fi
}
# check evn commands and java version
checkEnv() {
  commands_avaliable=true
  commands=(wget unzip lsof java)
  for cmd_name in "${commands[@]}"; do
    if ! command -v $cmd_name >/dev/null 2; then
      echo "$cmd_name needed,install it first."
      commands_avaliable=false
    fi
  done

  if ! $commands_avaliable;  then
    abort;
  fi

  version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  if  [[ "$version" < "11" ]]; then
    abort "Find java version $version,but at least 11 needed."
  fi

  if [ ! -f "/usr/lib64/libapr-1.so.0" ]; then
    abort "Install apr first."
  fi

  if [ ! -f "/usr/lib64/libtcnative-1.so" ]; then
    abort "Install tomcat-native first."
  fi
}

abort(){
  if [ "$1" != "" ]; then
    echo "$1"
  fi
  echo "Installation was aborted."
  exit 1;
}

  checkEnv

  echo "Downloading and link libraries..."
  download org.scala-lang scala3-library_3 $scala_ver
  download org.scala-lang scala-library $scala_lib_ver
  download org.scala-lang.modules scala-xml_3 $scalaxml_ver
  download org.beangle.commons beangle-commons-core_3     $beangle_commons_ver
  download org.beangle.commons beangle-commons-file_3     $beangle_commons_ver
  download org.beangle.data beangle-data-jdbc_3 $beangle_data_ver
  download org.beangle.template beangle-template-freemarker_3 $beangle_template_ver
  download org.beangle.boot beangle-boot_3 $beangle_boot_ver
  download org.beangle.sas beangle-sas-engine  $beangle_sas_ver
  download org.beangle.sas beangle-sas-core    $beangle_sas_ver
  download org.beangle.sas beangle-sas-agent   $beangle_sas_ver
  download org.beangle.sas beangle-sas-tomcat  $beangle_sas_ver
  download org.beangle.sas beangle-sas-juli    $beangle_sas_ver
  download org.apache.commons commons-compress $commons_compress_ver
  download org.freemarker freemarker $freemarker_ver
  download org.slf4j slf4j-api $slf4j_ver
  download ch.qos.logback logback-core $logback_ver
  download ch.qos.logback logback-classic $logback_ver
  download ch.qos.logback logback-access $logback_ver
  echo "Initialization Completed"
  if [ -f $SAS_HOME/conf/server.xml ]; then
    echo "Custom the conf/server.xml."
  fi
