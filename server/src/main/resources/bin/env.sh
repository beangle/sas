#!/bin/bash

if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

export scala_ver=3.2.2
export scala_lib_ver=2.13.10
export scalaxml_ver=2.1.0
export beangle_sas_ver=0.12.2
export beangle_commons_ver=5.5.0
export beangle_template_ver=0.1.4
export beangle_boot_ver=0.1.3
export slf4j_ver=2.0.6
export logback_ver=1.4.5
export freemarker_ver=2.3.32
export commons_compress_ver=1.22
export tomcat_ver=10.1.5
