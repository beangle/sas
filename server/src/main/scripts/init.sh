#!/bin/sh
PRGDIR=`dirname "$0"`

install_lib_of_versions(){
  name=$3[@]

  local versions=("${!name}")
  local finded=""
  local group_id=`echo "$1" | tr . /`
  for ver in "${versions[@]}" ;do
    local local_file="$M2_REPO/$group_id/$2/$ver/$2-$ver.jar"
    if [ -e $local_file ]; then
      finded=$ver
      break
    fi
  done

  if [ "$finded" == "" ]; then
    finded=${versions[0]}
  fi
  ./install.sh libx $1 $2 $finded
}

cd $PRGDIR
source ./setenv.sh

wget_avaliable=false
unzip_avaliable=false

if command -v wget >/dev/null 2; then
  wget_avaliable=true
fi

if command -v unzip >/dev/null 2; then
  unzip_avaliable=true
fi

if $wget_avaliable && $unzip_avaliable ;then
  install_lib_of_versions org.scala-lang scala-library scala_vers
  install_lib_of_versions org.scala-lang scala-reflect scala_vers
  install_lib_of_versions org.scala-lang.modules scala-xml_2.12.0-M4 scalaxml_vers

  ./install.sh libx org.beangle.commons beangle-commons-core_2.12 $beangle_commons_ver
  ./install.sh libx org.beangle.data beangle-data-jdbc_2.12 $beangle_data_ver
  ./install.sh libx org.beangle.template beangle-template-freemarker_2.12 $beangle_freemarker_ver
  ./install.sh libx org.beangle.tomcat beangle-tomcat-configer $beangle_server_ver
  ./install.sh libx org.beangle.tomcat beangle-tomcat-core     $beangle_server_ver
  ./install.sh libx org.freemarker freemarker $freemarker_ver
  ./install.sh libx org.slf4j slf4j-api $slf4j_ver
  ./install.sh libx org.slf4j slf4j-nop $slf4j_ver
  ./install.sh lib org.beangle.tomcat beangle-tomcat-core     $beangle_server_ver
elif $wget_avaliable; then
  echo "unzip needed,install it first."
elif $unzip_avaliable; then
  echo "wget needed,install it first."
else
  echo "wget and unzip needed,install them first."
fi

