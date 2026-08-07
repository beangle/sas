#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage:
   launch.sh [jvm_options] /path/to/war [--port=8080] [--path=/yourbase] [other_args]
   launch.sh [jvm_options] group_id:artifact_id:version [--engine=undertow/tomcat] [other_args]
   launch.sh [jvm_options] http://host.com/path/towar [other_args]"
  exit 1
fi

PRGDIR=$(dirname "$0")
export SAS_HOME=$(cd "$PRGDIR/../" >/dev/null; pwd)
. "$SAS_HOME/bin/env.sh"

# launch classpath
bootpath=""
# war file,may be groupid/file/url
warfile=""
#contextpath
app_name="ROOT"
#java options
options=""
#java args
args=""
classpath=""
sas_home="/tmp/sas"
engine="tomcat"

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
  local_file_path="$M2_REPO/$group_id/$2/$3/$2-$3.jar"
  bootpath=$bootpath":"$local_file_path

  if [ ! -f $local_file_path ]; then
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
    mv $artifact_name $local_file_path
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

# find warfile, application args and jvm options among all opts,order independent
parse_args(){
  for arg in "$@"
  do
    if [[ "$arg" == --path=* ]] ; then
      app_name=$(extract_arg_value "$arg")
      app_name=$(echo "$app_name" | tr '/' '#')
      app_name=${app_name#"#"}
      args="$args $arg"
    elif [[ "$arg" == --engine=* ]] ; then
      engine=$(extract_arg_value "$arg")
    elif [[ "$arg" == --* ]] ; then
      # sas options passed to Bootstrap (--port etc)
      args="$args $arg"
    elif [[ "$arg" == -D* || "$arg" == -X* || "$arg" == -XX* ]] ; then
      # jvm options
      options="$options $arg"
    else
      if [ -z "$warfile" ]; then
        warfile="$arg"
      else
        args="$args $arg"
      fi
    fi
  done

  # try to find warfile arg
  if [ -z "$warfile" ]; then
    echo "Cannot find jar file in args,launch was aborted."
    exit
  fi
}

parse_args "$@"

download org.scala-lang scala3-library_3 $scala_ver
download org.scala-lang scala-library $scala_lib_ver
download org.beangle.commons beangle-commons $beangle_commons_ver
download org.apache.commons commons-compress $commons_compress_ver
download org.beangle.boot beangle-boot $beangle_boot_ver
download org.slf4j slf4j-api $slf4j_ver
download org.slf4j jul-to-slf4j $slf4j_ver
download ch.qos.logback logback-core $logback_ver
download ch.qos.logback logback-classic $logback_ver
download org.beangle.sas beangle-sas-engine $beangle_sas_ver

download org.apache.tomcat.embed tomcat-embed-core $tomcat_ver
download org.apache.tomcat.embed tomcat-embed-websocket $tomcat_ver

download io.undertow undertow-core $undertow_ver
download io.undertow.ee undertow-servlet $undertow_ee_ver
download io.undertow.ee undertow-websockets $undertow_ee_ver
download org.jboss.logging jboss-logging 3.6.3.Final
download org.jboss.threads jboss-threads 3.9.2
download org.jboss.xnio xnio-api 3.8.16.Final
download org.jboss.xnio xnio-nio 3.8.16.Final
download jakarta.annotation jakarta.annotation-api 2.1.1
download jakarta.servlet jakarta.servlet-api 6.1.0
download jakarta.websocket jakarta.websocket-api 2.2.0
download jakarta.websocket jakarta.websocket-client-api 2.2.0
download org.wildfly.client wildfly-client-config 1.0.1.Final
download org.wildfly.common wildfly-common 2.0.1
download io.smallrye.common smallrye-common-annotation 2.14.0
download io.smallrye.common smallrye-common-constraint 2.12.0
download io.smallrye.common smallrye-common-cpu 2.14.0
download io.smallrye.common smallrye-common-expression 2.4.0
download io.smallrye.common smallrye-common-function 2.14.0
download io.smallrye.common smallrye-common-net 2.12.0
download io.smallrye.common smallrye-common-os 2.4.0
download io.smallrye.common smallrye-common-ref 2.4.0

bootpath="${bootpath:1}" #omit head :

#destfile is resolved absolute file path.
destfile=$(java -cp "$bootpath" org.beangle.boot.dependency.AppResolver $warfile --remote=$M2_REMOTE_REPO --local=$M2_REPO --quiet --preferwar)
if [ $? -ne 0  ]; then
  echo "Cannot resolve $warfile, Launching aborted."
  exit
fi

doc_base="$sas_home/webapps/$app_name"
rm -rf $doc_base
mkdir -p $doc_base
unzip $destfile -d $doc_base > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "unzip failed: $destfile -d $doc_base" >&2
  exit 1
fi

bootinfo=$(java -cp "$bootpath" org.beangle.boot.launcher.Classpath $doc_base --local=$M2_REPO)

if [ $? = 0 ]; then
  if [ "$engine" = "tomcat" ]; then
    mainclass="org.beangle.sas.engine.tomcat.Bootstrap"
    classpath="${bootinfo#*@}"
    classpath=$classpath":"$(local_file org.apache.tomcat.embed tomcat-embed-core $tomcat_ver)
    classpath=$classpath":"$(local_file org.apache.tomcat.embed tomcat-embed-websocket $tomcat_ver)
    classpath=$classpath":"$(local_file org.beangle.sas beangle-sas-engine $beangle_sas_ver)
    classpath=$classpath":"$(local_file org.slf4j slf4j-api $slf4j_ver)
    classpath=$classpath":"$(local_file org.slf4j jul-to-slf4j $slf4j_ver)
    classpath=$classpath":"$(local_file ch.qos.logback logback-core $logback_ver)
    classpath=$classpath":"$(local_file ch.qos.logback logback-classic $logback_ver)
    java -cp "$classpath" $options "$mainclass" --base=$sas_home $args
  elif [ "$engine" = "undertow" ]; then
    mainclass="org.beangle.sas.engine.undertow.Bootstrap"
    classpath="${bootinfo#*@}"
    classpath=$classpath":"$(local_file io.undertow undertow-core $undertow_ver)
    classpath=$classpath":"$(local_file io.undertow.ee undertow-servlet $undertow_ee_ver)
    classpath=$classpath":"$(local_file io.undertow.ee undertow-websockets $undertow_ee_ver)
    classpath=$classpath":"$(local_file org.jboss.logging jboss-logging 3.6.3.Final)
    classpath=$classpath":"$(local_file org.jboss.threads jboss-threads 3.9.2)
    classpath=$classpath":"$(local_file org.jboss.xnio xnio-api 3.8.16.Final)
    classpath=$classpath":"$(local_file org.jboss.xnio xnio-nio 3.8.16.Final)
    classpath=$classpath":"$(local_file jakarta.annotation jakarta.annotation-api 2.1.1)
    classpath=$classpath":"$(local_file jakarta.servlet jakarta.servlet-api 6.1.0)
    classpath=$classpath":"$(local_file jakarta.websocket jakarta.websocket-api 2.2.0)
    classpath=$classpath":"$(local_file jakarta.websocket jakarta.websocket-client-api 2.2.0)
    classpath=$classpath":"$(local_file org.wildfly.client wildfly-client-config 1.0.1.Final)
    classpath=$classpath":"$(local_file org.wildfly.common wildfly-common 2.0.1)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-annotation 2.14.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-constraint 2.12.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-cpu 2.14.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-expression 2.4.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-function 2.14.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-net 2.12.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-os 2.4.0)
    classpath=$classpath":"$(local_file io.smallrye.common smallrye-common-ref 2.4.0)

    classpath=$classpath":"$(local_file org.beangle.sas beangle-sas-engine $beangle_sas_ver)
    classpath=$classpath":"$(local_file org.slf4j slf4j-api $slf4j_ver)
    classpath=$classpath":"$(local_file org.slf4j jul-to-slf4j $slf4j_ver)
    classpath=$classpath":"$(local_file ch.qos.logback logback-core $logback_ver)
    classpath=$classpath":"$(local_file ch.qos.logback logback-classic $logback_ver)
    java -cp "$classpath" $options "$mainclass" --base=$sas_home $args
  else
    echo "unknown engine $engine,launch failed."
  fi
else
   echo "launch failed."
fi
