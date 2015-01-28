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

target="lib"

if [ "$4" != "" ]; then
    target="$4"
fi

mkdir -p $(dirname $0)/$target
cd $(dirname $0)/$target

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

