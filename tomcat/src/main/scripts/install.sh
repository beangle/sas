#!/bin/sh
PRGDIR=`dirname "$0"`

# download_lib groupId artifactId version target_dir
download_lib(){
  local group_id=`echo "$1" | tr . /`
  local URL="$M2_REMOTE_REPO/$group_id/$2/$3/$2-$3.jar"
  local artifact_name="$2-$3.jar"
  local local_file="$M2_REPO/$group_id/$2/$3/$2-$3.jar"
  local target="$4"

  mkdir -p $target
  cd $target
  if [ -f $artifact_name ]; then
    echo "$artifact_name existed."
  else
    if [ ! -f $local_file ]; then
      if wget --spider $URL 2>/dev/null; then
        echo "fetching $URL"
      else
        echo "$URL not exists,installation aborted."
        exit 1
      fi

      if command -v aria2c >/dev/null 2; then
        aria2c -x 16 $URL
      else
        wget $URL -O $artifact_name.part
        mv $artifact_name.part $artifact_name
      fi
      mkdir -p "$M2_REPO/$group_id/$2/$3"
      mv $artifact_name $local_file
      ln -s  $local_file
      echo "Downloaded $artifact_name"
    else
      ln -s  $local_file
      echo "Linked $artifact_name"
    fi
  fi
}

install_tomcat()
{
  cd $SERVER_HOME

  local tomcat_version=$1
  local tomcat_v=`echo $tomcat_version| cut -c 1-1`
  local tomcat_path="tomcat-$tomcat_v/v$tomcat_version/bin/apache-tomcat-$tomcat_version.zip"

  mkdir -p tmp
  cd tmp
  
  if [ ! -f apache-tomcat-$tomcat_version.zip ]; then
    local tomcat_url=$TOMCAT_REPO/$tomcat_path
    if wget --spider $TOMCAT_MIRROR/$tomcat_path 2>/dev/null; then
      tomcat_url=$TOMCAT_MIRROR/$tomcat_path
    fi

    if wget --spider $tomcat_url 2>/dev/null; then
      echo "Downloading $tomcat_url"
    else
      echo "Cannot find tomcat $tomcat_version, Installation aborted."
      exit 1
    fi
    if command -v aria2c >/dev/null 2; then
      aria2c -x 16 $tomcat_url
    else
      wget $tomcat_url -O apache-tomcat-$tomcat_version.zip.part
      mv apache-tomcat-$tomcat_version.zip.part  apache-tomcat-$tomcat_version.zip
    fi
  fi

  cd $SERVER_HOME

  if [ -f tmp/apache-tomcat-$tomcat_version.zip ]; then
    unzip -q tmp/apache-tomcat-$tomcat_version.zip
    rm -rf tomcat
    mv apache-tomcat-$tomcat_version tomcat
  else
    echo "Cannot find tmp/apache-tomcat-$tomcat_version.zip"
    return 0
  fi

  mkdir -p servers
  mkdir -p webapps

  rm -rf tomcat/work
  rm -rf tomcat/webapps
  rm -rf tomcat/logs
  rm -rf tomcat/temp
  rm -rf tomcat/RUNNING.txt
  rm -rf tomcat/NOTICE
  rm -rf tomcat/LICENSE
  rm -rf tomcat/RELEASE-NOTES

  rm -rf tomcat/conf/server.xml
  rm -rf tomcat/bin/*.xml
  rm -rf tomcat/bin/*.bat
  rm -rf tomcat/bin/*native.tar.gz
  rm -rf tomcat/bin/*daemon*
  rm -rf tomcat/bin/startup.sh
  rm -rf tomcat/bin/shutdown.sh
  rm -rf tomcat/bin/configtest.sh
  rm -rf tomcat/bin/version.sh
  rm -rf tomcat/bin/digest.sh
  rm -rf tomcat/bin/tool-wrapper.sh
  chmod a+x tomcat/bin/*.sh

  echo "$tomcat_version installed successfully."
}

function check_tomcat(){
  cd $SERVER_HOME
  local ver=""
  local version=$1

  if [ -d tomcat ] && [ -a tomcat/bin/catalina.sh ]; then
    ver=$(tomcat/bin/catalina.sh version |grep version)
    ver=${ver##*/}
  fi

  eval $version="'$ver'"
}

function display_usage(){
  echo "Usage:"
  echo "     install.sh driver [what]"
  echo "     install.sh tomcat version"
  echo "     install.sh lib groupId artifactId version"
  echo ""
  echo "Example: "
  echo "     install.sh tomcat 8.0.36"
}

function install_driver(){
  #local driver="$1"
  local options=("oracle" "postgresql" "mysql" "sqlserver" "h2")
  select driver in "${options[@]}"; do
    break
  done

  if [ "$driver" == "" ]; then
    echo invalid driver
    exit 1
  fi

  local groupId=""
  local artifactId=""
  local versions=()
  case $driver in
      "oracle")
        groupId="oracle"
        artifactId="ojdbc6"
        versions=("11.2.0.3")
        ;;
      "postgresql")
        groupId="org.postgresql"
        artifactId="postgresql"
        versions=("9.4.1208" "9.3-1103-jdbc41")
        ;;
      "mysql")
        groupId="mysql"
        artifactId="mysql-connector-java"
        versions=("6.0.2" "5.1.39")
        ;;
      "sqlserver")
        groupId="net.sourceforge.jtds"
        artifactId="jtds"
        versions=("1.3.1" "1.2.8")
        ;;
      "h2")
        groupId="com.h2database"
        artifactId="h2"
        versions=("1.4.192")
        ;;
      *)
        echo invalid option
        exit 1
        ;;
  esac

  versionnum=${#versions[@]}
  if [ ${versionnum} -eq 1 ]; then
    ver=${versions[0]}
  else
    select ver in ${versions[@]}; do
      case $ver in
        *)
          if [ "$ver" == "custom" ] ||  [ "$ver" == "" ] ; then
            echo -n "Enter Your version:"
            read ver
          fi
          break ;;
      esac
    done
  fi

  if [ "$1" == "oracle" ]; then
    M2_REMOTE_REPO=$M2_REMOTE_REPO_ORACLE
  fi
  download_lib $groupId $artifactId $ver $SERVER_HOME/lib
}


SERVER_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`
source $SERVER_HOME/bin/setenv.sh

# 1.install tomcat server
if [ "$1" == "tomcat" ]; then
  tomcat_version="$2"
  if [ "${tomcat_version:0:1}" \< "8" ]; then
    echo "Beangle Tomcat Server Only supports 8 or higher versions!"
    exit
  fi

  check_tomcat installed_version
  cd $SERVER_HOME
  if [ "$installed_version" = "" ]; then
    install_tomcat $tomcat_version
  else
    echo "Tomcat $installed_version had bean installed."
    if [ "$installed_version" != "$tomcat_version" ]; then
      read -p "Are you update tomcat to $tomcat_version(Y/n)? " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_tomcat $tomcat_version
      fi
    fi
  fi

elif [ "$1" == "lib" ]; then
  if [ "$4" == "" ]; then
    display_usage
  else
    download_lib $2 $3 $4 $SERVER_HOME/lib
  fi

elif [ "$1" == "libx" ]; then
  download_lib $2 $3 $4 $SERVER_HOME/bin/lib

elif [ "$1" == "driver" ]; then
  install_driver

else
  display_usage
fi
