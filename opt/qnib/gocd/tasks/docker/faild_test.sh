#!/bin/bash
set -e

IMG_NAME=$(echo ${GO_PIPELINE_NAME} |awk -F'[\_\.]' '{print $1}')
if [ -z ${GO_REVISION} ];then
    export BUILD_IMG_NAME="${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}-${GO_REVISION_DOCKER_}-rev${GO_PIPELINE_COUNTER}"
else
    export BUILD_IMG_NAME="${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}-${GO_REVISION}-rev${GO_PIPELINE_COUNTER}"
fi
echo ">> BUILD_IMG_NAME:${BUILD_IMG_NAME}"


IMG_NAME=$(echo ${GO_PIPELINE_NAME} |awk -F'[\_\.]' '{print $1}')

if [ -d docker ];then
    cd docker
fi


if [ -d test ];then
    cd test
    if [ -x stop.sh ];then
        ./stop.sh
    fi
fi
docker rmi ${BUILD_IMG_NAME}
exit 1
