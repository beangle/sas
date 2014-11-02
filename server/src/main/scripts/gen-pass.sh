#!/bin/sh
PRGDIR=`dirname "$0"`
java -cp "$PRGDIR/lib/*" org.beangle.tomcat.jdbc.Encryptor $1
