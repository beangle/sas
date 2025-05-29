#!/bin/bash
if [ $(id -u) = 0 ]; then
  echo -e "\033[31m Please run this command in a non root environment. \033[0m"
  exit 1
fi

if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

export scala_ver=3.3.6
export scala_lib_ver=2.13.16
export scalaxml_ver=2.4.0
export beangle_sas_ver=0.12.12
export beangle_commons_ver=5.6.28
export beangle_template_ver=0.1.26
export beangle_boot_ver=0.1.16
export slf4j_ver=2.0.17
export logback_ver=1.5.18
export logback_access_ver=2.0.6
export freemarker_ver=2.3.34
export commons_compress_ver=1.27.1
export tomcat_ver=11.0.7
