#!/bin/sh
PRGDIR=`dirname "$0"`
SAS_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

cd $PRGDIR
source ./setenv.sh

# download groupId artifactId version
function download(){
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

wget_avaliable=false
unzip_avaliable=false
bspatch_avaliable=false

if command -v wget >/dev/null 2; then
  wget_avaliable=true
fi

if command -v unzip >/dev/null 2; then
  unzip_avaliable=true
fi

if command -v bspatch >/dev/null 2; then
  bspatch_avaliable=true
fi

if $wget_avaliable && $unzip_avaliable && $bspatch_avaliable; then
  echo "Downloading and link libraries."
  download org.scala-lang scala-library $scala_ver
  download org.scala-lang scala-reflect $scala_ver
  download org.scala-lang.modules scala-xml_2.12 $scalaxml_ver
  download org.beangle.commons beangle-commons-core_2.12     $beangle_commons_ver
  download org.beangle.data beangle-data-jdbc_2.12 $beangle_data_ver
  download org.beangle.template beangle-template-freemarker_2.12 $beangle_template_ver
  download org.beangle.maven beangle-maven-artifact_2.12 $beangle_maven_ver
  download org.beangle.sas beangle-sas-config $beangle_sas_ver
  download org.beangle.sas beangle-sas-core   $beangle_sas_ver
  download org.freemarker freemarker $freemarker_ver
  download org.slf4j slf4j-api $slf4j_ver
  download org.slf4j slf4j-nop $slf4j_ver
  echo "Initialization Completed.You can custom conf/server.xml."
else
  if ! $wget_avaliable; then
    echo "wget needed,install it first."
  fi
  if ! $unzip_avaliable; then
    echo "unzip needed,install it first."
  fi
  if ! $bspatch_avaliable; then
    echo "bspatch needed,install it first."
  fi
fi
