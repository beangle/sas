#!/bin/sh
export TOMCAT_MIRROR="http://mirrors.cnnic.cn/apache/tomcat"
export TOMCAT_REPO="http://archive.apache.org/dist/tomcat"
export M2_REMOTE_REPO="http://maven.aliyun.com/nexus/content/groups/public"
export M2_REPO="$HOME/.m2/repository"
export M2_REMOTE_REPO_ORACLE="http://www.datanucleus.org/downloads/maven2"

export scala_vers=("2.12.1")
export scalaxml_vers=("1.0.6")
export beangle_as_ver=0.2.7
export beangle_commons_ver=4.6.0
export beangle_data_ver=4.4.2
export slf4j_ver=1.7.21
export freemarker_ver=2.3.25-incubating