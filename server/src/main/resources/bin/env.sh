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

export scala_ver=3.3.3
export scala_lib_ver=2.13.12
export scalaxml_ver=2.2.0
export beangle_sas_ver=0.12.6
export beangle_commons_ver=5.6.11
export beangle_template_ver=0.1.11
export beangle_boot_ver=0.1.9
export slf4j_ver=2.0.12
export logback_ver=1.5.0
export freemarker_ver=2.3.32
export commons_compress_ver=1.26.0
export tomcat_ver=10.1.18
