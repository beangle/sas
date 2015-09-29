#!/bin/sh
export TOMCAT_MIRROR="http://mirror.bit.edu.cn/apache/tomcat"
export TOMCAT_REPO="http://archive.apache.org/dist/tomcat"
export M2_REMOTE_REPO="http://maven.oschina.net/content/groups/public"
#export M2_REMOTE_REPO="http://repo1.maven.org/maven2"
export M2_REPO="$HOME/.m2/repository"
export M2_REMOTE_REPO_ORACLE="http://www.datanucleus.org/downloads/maven2"

export scala_vers=("2.11.6" "2.11.4" "2.11.2")
export scalaxml_vers=("1.0.4" "1.0.3" "1.0.2" "1.0.1")
export beangle_server_ver=0.2.2
