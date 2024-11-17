#!/bin/bash

PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
. "$SAS_HOME/bin/env.sh"

if [ -x "$SAS_HOME/bin/setenv.sh" ]; then
  . "$SAS_HOME/bin/setenv.sh"
fi

mkdir -p $SAS_HOME/conf
if [ ! -f $SAS_HOME/conf/server.xml ] && [ $sas_remote_url ]; then
  wget -q $sas_remote_url/config/server.xml -O $SAS_HOME/conf/server.xml
fi

# download groupId artifactId version
download(){
  local group_id=$(echo "$1" | tr . /)
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
        return 1
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
  if  [[ "$version" < "17" ]]; then
    abort "Find java version $version,but at least 17 needed."
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
  artifacts=("org.scala-lang:scala3-library_3:$scala_ver"
             "org.scala-lang:scala-library:$scala_lib_ver"
             "org.scala-lang.modules:scala-xml_3:$scalaxml_ver"
             "org.beangle.commons:beangle-commons:$beangle_commons_ver"
             "org.beangle.template:beangle-template:$beangle_template_ver"
             "org.beangle.boot:beangle-boot:$beangle_boot_ver"
             "org.beangle.sas:beangle-sas-engine:$beangle_sas_ver"
             "org.beangle.sas:beangle-sas-core:$beangle_sas_ver"
             "org.beangle.sas:beangle-sas-juli:$beangle_sas_ver"
             "org.apache.commons:commons-compress:$commons_compress_ver"
             "org.freemarker:freemarker:$freemarker_ver"
             "org.slf4j:slf4j-api:$slf4j_ver"
             "ch.qos.logback:logback-core:$logback_ver"
             "ch.qos.logback:logback-classic:$logback_ver"
             "ch.qos.logback.access:logback-access-common:$logback_access_ver"
             "ch.qos.logback.access:logback-access-tomcat:$logback_access_ver")

  echo "Downloading and link libraries..."
  for artifact in ${artifacts[@]}; do
    gav=($(echo $artifact | tr ":" "\n"))
    download "${gav[0]}" "${gav[1]}"  "${gav[2]}"
  done


  missing_count=0

  for artifact in ${artifacts[@]}; do
    gav=($(echo $artifact | tr ":" "\n"))
    group_id=$(echo "${gav[0]}" | tr . /)
    local_file="$M2_REPO/$group_id/${gav[1]}/${gav[2]}/${gav[1]}-${gav[2]}.jar"
    if [ ! -f "$local_file" ]; then
       echo "missing $local_file"
       missing_count=$((missing_count+1))
    fi
  done

  if [ $missing_count = 0 ];then
    echo "Initialization Completed"
    if [ -f $SAS_HOME/conf/server.xml ]; then
      echo "Custom the conf/server.xml."
    fi
  else
    rm -rf $SAS_HOME/bin/lib
    echo "missing $missing_count artifacts"
    exit 1
  fi

