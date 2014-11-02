#!/bin/sh

if [ "$3" == "" ]; then
    echo "Usage: get-lib.sh groupId artifactId version"
    echo "Example: get-lib.sh org.slf4j slf4j-api 1.3.0"
    exit
fi

source $(dirname $0)/setrepo.sh

GROUPID=`echo "$1" | tr . /`
URL="$M2_REMOTE_REPO/$GROUPID/$2/$3/$2-$3.jar"
ARTIFACT_NAME="$2-$3.jar"
LOCAL_FILE="$M2_REPO/$GROUPID/$2/$3/$2-$3.jar"

mkdir -p $(dirname $0)/lib
cd $(dirname $0)/lib

if [ ! -f $LOCAL_FILE ]; then
    if command -v aria2c >/dev/null 2; then
        aria2c -x 16 $URL
    else
        wget $URL -O $ARTIFACT.part
        mv $ARTIFACT.part $ARTIFACT
    fi
    mkdir -p "$M2_REPO/$GROUPID/$2/$3"
    mv $ARTIFACT_NAME $LOCAL_FILE
    ln -s  $LOCAL_FILE
    echo "Downloaded $ARTIFACT_NAME"
else
    ln -s  $LOCAL_FILE 
    echo "Linked $ARTIFACT_NAME"
fi

cd ..
