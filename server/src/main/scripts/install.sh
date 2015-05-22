#!/bin/sh
PRGDIR=`dirname "$0"`

export SERVER_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

install_lib()
{
  source $(dirname $0)/setrepo.sh

  local GROUPID=`echo "$1" | tr . /`
  local URL="$M2_REMOTE_REPO/$GROUPID/$2/$3/$2-$3.jar"
  local ARTIFACT_NAME="$2-$3.jar"
  local LOCAL_FILE="$M2_REPO/$GROUPID/$2/$3/$2-$3.jar"

  local target="../ext"

  if [ "$4" != "" ]; then
    target="$4"
  fi

  mkdir -p $(dirname $0)/$target
  cd "$(dirname $0)/$target"

  if [ -f $ARTIFACT_NAME ]; then
    echo "$ARTIFACT_NAME existed."
    exit
  fi

  if [ ! -f $LOCAL_FILE ]; then
    if command -v aria2c >/dev/null 2; then
      echo "Using aria2c fetch remote jar..."
      aria2c -x 16 $URL
    else
      echo "Using wget fetch remote jar..."
      wget $URL -O $ARTIFACT_NAME.part
      mv $ARTIFACT_NAME.part $ARTIFACT_NAME
    fi
    mkdir -p "$M2_REPO/$GROUPID/$2/$3"
    mv $ARTIFACT_NAME $LOCAL_FILE
    ln -s  $LOCAL_FILE
    echo "Downloaded $ARTIFACT_NAME"
  else
    ln -s  $LOCAL_FILE
    echo "Linked $ARTIFACT_NAME"
  fi
}

install_war(){

  source $(dirname $0)/setrepo.sh

  local GROUPID=`echo "$1" | tr . /`
  local URL="$M2_REMOTE_REPO/$GROUPID/$2/$3/$2-$3.war"
  local ARTIFACT_NAME="$2-$3.war"

  cd $(dirname $0)/../webapps

  if command -v aria2c >/dev/null 2; then
    aria2c -x 16 $URL
  else
    wget $URL -O $ARTIFACT_NAME.part
    mv $ARTIFACT_NAME.part $ARTIFACT_NAME
  fi
}

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

  rm -rf tomcat/bin/*.xml
  rm -rf tomcat/bin/*.bat
  rm -rf tomcat/bin/startup.sh
  rm -rf tomcat/bin/shutdown.sh
  rm -rf tomcat/bin/configtest.sh
  rm -rf tomcat/bin/digest.sh
  rm -rf tomcat/bin/tool-wrapper.sh
  chmod a+x tomcat/bin/*.sh

  [ ! -d conf ] && mkdir conf

  rm -rf tomcat/conf
  cd tomcat
  ln -s ../conf
  cd ..

  shopt -s nullglob
  if [ -d ext ] ; then
    for jar in ext/*.jar ;do
      cp $jar tomcat/lib/
    done
  fi

  echo "$TOMCAT_VERSION installed successfully."
}

function check_tomcat(){
  cd $SERVER_HOME
  local ver=""
  local version=$1

  if [ -d tomcat ] && [ -a tomcat/bin/version.sh ]; then
    ver=$(tomcat/bin/version.sh |grep version)
    local slash_idx=$(echo $ver | grep -bo / | sed 's/:.*$//')
    ver="${ver:($slash_idx+1)}"
  fi

  eval $version="'$ver'"
}

function display_usage(){
  echo "Usage:"
  echo "     install.sh lib groupId artifactId version"
  echo "     install.sh war groupId artifactId version"
  echo "     install.sh tomcat version"
  echo ""
  echo "Example: "
  echo "     install.sh lib org.slf4j slf4j-api 1.3.0"
  echo "     install.sh tomcat 8.0.22"
}
# 1.install tomcat server
if [ "$1" == "tomcat" ]; then
  export TOMCAT_VERSION="$2"
  if [ "${TOMCAT_VERSION:0:1}" \< "8" ]; then
    echo "Beangle Tomcat Server Only supports 8 or higher versions!"
    exit
  fi

  check_tomcat OLD_VER
  cd $SERVER_HOME
  if [ "$OLD_VER" = "" ]; then
    install_tomcat
  else
    echo "Tomcat ${OLD_VER} had bean installed."
    if [ "$OLD_VER" != "$TOMCAT_VERSION" ]; then
      read -p "Are you update tomcat to $TOMCAT_VERSION(Y/n)? " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_tomcat
      fi
    fi
  fi

elif [ "$1" == "lib" ]; then
  if [ "$4" == "" ]; then
    display_usage
  else
    install_lib $2 $3 $4 $5
  fi
elif [ "$1" == "war" ]; then
  if [ "$4" == "" ]; then
    display_usage
  else
    install_war $2 $3 $4
  fi
else
  display_usage
fi
