#!/bin/sh

source $(dirname $0)/setrepo.sh

TOMCAT_V=`echo $TOMCAT_VERSION| cut -c 1-1`
TOMCAT_URL="$TOMCAT_REPO/tomcat-$TOMCAT_V/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.zip"

if [ ! -f apache-tomcat-$TOMCAT_VERSION.zip ]; then
    if command -v aria2c >/dev/null 2; then
        echo "Downloading $TOMCAT_URL"
        aria2c -x 16 $TOMCAT_URL
    else
        wget $TOMCAT_URL -O apache-tomcat-$TOMCAT_VERSION.zip.part
        mv apache-tomcat-$TOMCAT_VERSION.zip.part  apache-tomcat-$TOMCAT_VERSION.zip
    fi

    unzip -q apache-tomcat-$TOMCAT_VERSION.zip
    rm -rf apache-tomcat-$TOMCAT_VERSION.zip
    rm -rf tomcat
    mv apache-tomcat-$TOMCAT_VERSION tomcat
    
else
    unzip -q apache-tomcat-$TOMCAT_VERSION.zip
    rm -rf tomcat
    mv apache-tomcat-$TOMCAT_VERSION tomcat
fi


mkdir -p servers
mkdir -p webapps

rm -rf tomcat/work
rm -rf tomcat/webapps
rm -rf tomcat/logs
rm -rf tomcat/conf
rm -rf tomcat/temp
rm -rf tomcat/RUNNING.txt
rm -rf tomcat/NOTICE
rm -rf tomcat/LICENSE
rm -rf tomcat/RELEASE-NOTES

rm -rf tomcat/bin/*.bat
rm -rf tomcat/bin/startup.sh
rm -rf tomcat/bin/shutdown.sh
chmod a+x tomcat/bin/*.sh

rm -rf tomcat/conf
cd tomcat
ln -s ../conf
cd ..
cp -r bin/lib/*.jar tomcat/lib

rm -rf conf/version.txt
touch conf/version.txt
echo $TOMCAT_VERSION >> conf/version.txt

echo "$TOMCAT_VERSION installed successfully."
