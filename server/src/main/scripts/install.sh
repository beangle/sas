#!/bin/sh
PRGDIR=`dirname "$0"`

export SERVER_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

install_tomcat()
{
    cd $SERVER_HOME

    source $SERVER_HOME/bin/setrepo.sh
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

        if [ -f apache-tomcat-$TOMCAT_VERSION.zip ]; then
            unzip -q apache-tomcat-$TOMCAT_VERSION.zip
            #rm -rf apache-tomcat-$TOMCAT_VERSION.zip
            rm -rf tomcat
            mv apache-tomcat-$TOMCAT_VERSION tomcat
        fi
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

    echo "$TOMCAT_VERSION installed successfully."
}

if [ "$1" = "" ]; then
    echo "Usage: install.sh version"
    echo "Example: install.sh 8.0.17"
    exit
else
    export TOMCAT_VERSION="$1"
    if [ "${TOMCAT_VERSION:0:1}" \< "8" ]; then
        echo "Beangle Tomcat Server Only supports 8 or higher versions!"
        exit
    fi
fi

cd $SERVER_HOME
OLD_VER=""

if [ -d tomcat ] && [ -a tomcat/bin/version.sh ]; then
    OLD_VER=$(tomcat/bin/version.sh |grep version)
    SLASH_IDX=$(echo $OLD_VER | grep -bo / | sed 's/:.*$//')
    OLD_VER="${OLD_VER:($SLASH_IDX+1)}"
    echo "Tomcat ${OLD_VER} already installed."
fi

if [ "$OLD_VER" = "" ]; then
    install_tomcat
else
    if [ "$OLD_VER" != "$TOMCAT_VERSION" ]; then
        read -p "Are you update tomcat to $TOMCAT_VERSION(Y/n)? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_tomcat
        fi
    fi
fi

