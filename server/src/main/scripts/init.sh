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
  ./install.sh lib $1 $2 $finded lib
}

cd $PRGDIR
source ./setenv.sh
install_lib_of_versions org.scala-lang scala-library scala_vers
install_lib_of_versions org.scala-lang scala-reflect scala_vers
install_lib_of_versions org.scala-lang.modules scala-xml_2.12.0-M4 scalaxml_vers

./install.sh lib org.beangle.commons beangle-commons-core_2.12 4.5.0 lib
./install.sh lib org.beangle.data beangle-data-jdbc_2.12 4.4.0 lib
./install.sh lib org.beangle.template beangle-template-freemarker_2.12 0.0.11 lib
./install.sh lib org.beangle.tomcat beangle-tomcat-configer $beangle_server_ver lib
./install.sh lib org.freemarker freemarker 2.3.24-incubating lib
./install.sh lib org.slf4j slf4j-api 1.7.21 lib
./install.sh lib org.slf4j slf4j-nop 1.7.21 lib

./install.sh tomcat 8.0.35
