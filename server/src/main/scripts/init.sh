#!/bin/sh

bin/get-scala.sh 2.11.2
bin/get-pg-driver.sh
bin/get-lib.sh org.beangle.tomcat beangle-tomcat-core 0.1.1
bin/get-ext.sh org.beangle.commons beangle-commons-core 4.2.2
bin/get-ext.sh org.beangle.tomcat beangle-tomcat-configer 0.1.1
bin/get-ext.sh org.freemarker freemarker 2.3.20
bin/get-ext.sh org.slf4j slf4j-api 1.7.7
bin/install.sh
