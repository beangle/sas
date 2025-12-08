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
# war file,may be groupid/file/url
warfile=""
#contextpath
context_path="ROOT"
#java options
options=""
#java args
args=""
classpath=""
sas_home="/tmp/sas"

local_file(){
  group_id=$(echo "$1" | tr . /)
  echo "$M2_REPO/$group_id/$2/$3/$2-$3.jar"
}

# download groupId artifactId version
# add append bootpath
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

# extract_arg "--path = /tmp"
extract_arg_value() {
  local input="$1"
  # 匹配 = 后的内容（去掉前面所有字符）
  local temp=${input#*=}
  # 去首尾空格
  echo "$temp" | xargs  # 去首尾空格
}

#find warfile/content_path in all opts
parse_args(){
  for arg in $opts
  do
    if [ "$arg" = "${arg#"-"}" ]; then
      warfile="$arg"
    elif [[ "$arg" == --path* ]] ; then
      context_path=$(extract_arg_value "$arg")
      context_path=$(echo "$context_path" | tr '/' '#')
      context_path=${context_path#"#"}
    fi
  done

  # try to find warfile arg
  if [ -z "$warfile" ]; then
    echo "Cannot find jar file in args,launch was aborted."
    exit
  fi

  #get options and args of java program,(format is options warfile args)
  options="${opts%%$warfile*}"
  args="${opts#*$warfile}"
}

parse_args

download org.scala-lang scala3-library_3 $scala_ver
download org.scala-lang scala-library $scala_lib_ver
download org.beangle.commons beangle-commons $beangle_commons_ver
download org.apache.commons commons-compress $commons_compress_ver
download org.beangle.boot beangle-boot $beangle_boot_ver
download org.slf4j slf4j-api $slf4j_ver
download ch.qos.logback logback-core $logback_ver
download ch.qos.logback logback-classic $logback_ver
download org.apache.tomcat.embed tomcat-embed-core $tomcat_ver
download org.apache.tomcat.embed tomcat-embed-websocket $tomcat_ver
download org.beangle.sas beangle-sas-engine $beangle_sas_ver
bootpath="${bootpath:1}" #omit head :

#destfile is resolved absolute file path.
destfile=$(java -cp "$bootpath" org.beangle.boot.dependency.AppResolver $warfile --remote=$M2_REMOTE_REPO --local=$M2_REPO --quiet --preferwar)
if [ $? -ne 0  ]; then
  echo "Cannot resolve $warfile, Launching aborted."
  exit
fi

doc_base="$sas_home/webapps/$context_path"
rm -rf $doc_base
mkdir -p $doc_base
unzip $destfile -d $doc_base > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "unzip failed: $destfile -d $doc_base" >&2
  exit 1
fi

bootinfo=$(java -cp "$bootpath" org.beangle.boot.launcher.Classpath $doc_base --local=$M2_REPO)

if [ $? = 0 ]; then
  mainclass="org.beangle.sas.engine.tomcat.Bootstrap"
  classpath="${bootinfo#*@}"
  classpath=$classpath":"$(local_file org.apache.tomcat.embed tomcat-embed-core $tomcat_ver)
  classpath=$classpath":"$(local_file org.apache.tomcat.embed tomcat-embed-websocket $tomcat_ver)
  classpath=$classpath":"$(local_file org.beangle.sas beangle-sas-engine $beangle_sas_ver)
  java -cp "$classpath" $options "$mainclass" --base=$sas_home $args
else
   echo "launch failed."
fi
