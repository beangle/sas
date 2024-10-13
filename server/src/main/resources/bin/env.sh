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

export scala_ver=3.3.4
export scala_lib_ver=2.13.14
export scalaxml_ver=2.3.0
export beangle_sas_ver=0.12.7
export beangle_commons_ver=5.6.18
export beangle_template_ver=0.1.19
export beangle_boot_ver=0.1.13
export slf4j_ver=2.0.15
export logback_ver=1.5.8
export freemarker_ver=2.3.33
export commons_compress_ver=1.27.1
export tomcat_ver=10.1.30
