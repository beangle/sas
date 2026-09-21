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

export scala_ver=3.9.0
export scalaxml_ver=2.5.0
export beangle_sas_ver=0.13.14
export beangle_commons_ver=6.3.7
export beangle_template_ver=0.2.14
export beangle_boot_ver=0.1.29
export slf4j_ver=2.0.19
export logback_ver=1.6.3
export freemarker_ver=2.3.35
export commons_compress_ver=1.28.0
export tomcat_ver=11.0.26
export undertow_ver=2.4.3.Final
export undertow_ee_ver=2.0.2.Final
