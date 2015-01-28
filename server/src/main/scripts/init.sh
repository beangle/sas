#!/bin/sh

PRGDIR=`dirname "$0"`
cd $PRGDIR

PG_VER="9.3-1102-jdbc4"
SCALA_VER="2.11.2"

./get-lib.sh org.scala-lang scala-library $SCALA_VER
./get-lib.sh org.scala-lang scala-reflect $SCALA_VER
./get-lib.sh org.scala-lang.modules scala-xml_2.11 1.0.2
    
./get-lib.sh org.postgresql postgresql $PG_VER

./get-lib.sh org.beangle.tomcat beangle-tomcat-core 0.2.0
./get-lib.sh org.beangle.commons beangle-commons-core 4.2.2 ext
./get-lib.sh org.beangle.tomcat beangle-tomcat-configer 0.2.0 ext
./get-lib.sh org.freemarker freemarker 2.3.20 ext
./get-lib.sh org.slf4j slf4j-api 1.7.7 ext
./get-lib.sh org.slf4j slf4j-nop 1.7.7 ext
