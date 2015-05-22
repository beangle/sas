#!/bin/sh

PRGDIR=`dirname "$0"`
cd $PRGDIR

#PG_VER="9.3-1102-jdbc4"
#./install-lib.sh org.postgresql postgresql $PG_VER
SCALA_VER="2.11.6"

./install.sh lib org.scala-lang scala-library $SCALA_VER lib
./install.sh lib org.scala-lang scala-reflect $SCALA_VER lib
./install.sh lib org.scala-lang.modules scala-xml_2.11 1.0.3 lib
./install.sh lib org.beangle.commons beangle-commons-core 4.2.4 lib
./install.sh lib org.beangle.tomcat beangle-tomcat-configer 0.2.1-SNAPSHOT lib
./install.sh lib org.freemarker freemarker 2.3.20 lib
./install.sh lib org.slf4j slf4j-api 1.7.7 lib
./install.sh lib org.slf4j slf4j-nop 1.7.7 lib

./install.sh lib org.beangle.tomcat beangle-tomcat-core 0.2.1-SNAPSHOT
./install.sh lib org.beangle.maven beangle-maven-launcher 0.1.6-SNAPSHOT
./install.sh tomcat 8.0.22
