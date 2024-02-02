#!/bin/bash

if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

export scala_ver=3.3.1
export scala_lib_ver=2.13.12
export scalaxml_ver=2.2.0
export beangle_sas_ver=0.12.5
export beangle_commons_ver=5.6.10
export beangle_template_ver=0.1.10
export beangle_boot_ver=0.1.8
export slf4j_ver=2.0.10
export logback_ver=1.4.14
export freemarker_ver=2.3.32
export commons_compress_ver=1.25.0
export tomcat_ver=10.1.17
