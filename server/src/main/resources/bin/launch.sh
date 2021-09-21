#!/bin/sh
if [ $# -eq 0 ]; then
  echo "Usage:
   launch.sh [jvm_options] /path/to/war [args]
   launch.sh [jvm_options] group_id:artifact_id:war:version [args]
   launch.sh [jvm_options] http://host.com/path/towar [args]"
  exit 1
fi

if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

# launch classpath
bootpath=""
# full command line to java
opts="$*"
# war file
warfile=""

# download groupId artifactId version
download(){
  group_id=`echo "$1" | tr . /`
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

export_extra_classpath() {
  classpath_prefix="-cp"
  classpath_extra=$(echo "$*" | sed 's/^.*-cp \(\S*\) .*$/\1/')
  if [ "$*" = "$classpath_extra" ]; then
    classpath_prefix="-classpath"
    classpath_extra=$(echo "$*" | sed 's/^.*-classpath \(\S*\) .*$/\1/')
  fi
  if [ "$*" = "$classpath_extra" ]; then
    classpath_prefix="--class-path"
    classpath_extra=$(echo "$*" | sed 's/^.*--class-path \(\S*\) .*$/\1/')
  fi

  if [ "$*" != "$classpath_extra" ]; then
    classpath_str="$classpath_prefix $classpath_extra"
    export classpath_extra
    opts="${opts#*"$classpath_str"}"
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

export scala_ver=3.0.1
export scala_lib_ver=2.13.6

export beangle_commons_ver=5.2.5
export slf4j_ver=2.0.0-alpha4
export logback_ver=1.3.0-alpha9
export commons_compress_ver=1.21
export boot_ver=0.0.24
export sas_ver=0.9.1

download org.scala-lang scala3-library_3 $scala_ver
download org.scala-lang scala-library $scala_lib_ver
download org.beangle.commons beangle-commons-core_3  $beangle_commons_ver
download org.beangle.commons beangle-commons-file_3  $beangle_commons_ver
download org.apache.commons commons-compress $commons_compress_ver
download org.beangle.boot beangle-boot_3 $boot_ver
download org.slf4j slf4j-api $slf4j_ver
download ch.qos.logback logback-core $logback_ver
download ch.qos.logback logback-classic $logback_ver

export_extra_classpath "$opts"
detect_warfile
#get options and args of java program
args="${opts#*$warfile}"
options="${opts%%$warfile*}"
java -cp "${bootpath:1}" org.beangle.boot.dependency.AppResolver $warfile $M2_REMOTE_REPO $M2_REPO
bootpath=""
download org.beangle.sas beangle-sas-tomcat $sas_ver
download org.beangle.sas beangle-sas-engine $sas_ver
download org.apache.tomcat.embed tomcat-embed-core $tomcat_ver
download org.apache.tomcat.embed tomcat-embed-jasper $tomcat_ver

java -cp "${bootpath:1}" $options "org.beangle.sas.engine.tomcat.Bootstrap" $args
