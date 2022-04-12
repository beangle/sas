#!/bin/sh

if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

export scala_ver=3.1.2
export scala_lib_ver=2.13.8
export scalaxml_ver=2.1.0
export beangle_sas_ver=0.9.4
export beangle_commons_ver=5.2.13
export beangle_template_ver=0.0.37
export beangle_data_ver=5.4.0
export beangle_boot_ver=0.0.29
export slf4j_ver=2.0.0-alpha7
export logback_ver=1.3.0-alpha14
export freemarker_ver=2.3.31
export commons_compress_ver=1.21
export tomcat_ver=10.0.20
