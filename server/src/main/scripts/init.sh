#!/bin/sh
PRGDIR=`dirname "$0"`

install_lib(){
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
install_lib org.scala-lang scala-library scala_vers
install_lib org.scala-lang scala-reflect scala_vers
install_lib org.scala-lang.modules scala-xml_2.11 scalaxml_vers

./install.sh lib org.beangle.commons beangle-commons-core 4.2.4 lib
./install.sh lib org.beangle.data beangle-data-jdbc 4.2.1 lib
./install.sh lib org.beangle.tomcat beangle-tomcat-configer $beangle_server_ver lib
./install.sh lib org.freemarker freemarker 2.3.20 lib
./install.sh lib org.slf4j slf4j-api 1.7.7 lib
./install.sh lib org.slf4j slf4j-nop 1.7.7 lib

./install.sh tomcat 8.0.23
