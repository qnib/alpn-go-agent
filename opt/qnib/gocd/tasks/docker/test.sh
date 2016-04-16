#!/bin/bash
set -e

export IMG_NAME=$(echo ${GO_PIPELINE_NAME} |awk -F'[\_\.]' '{print $1}')
if [ -z ${GO_REVISION} ];then
    export BUILD_IMG_NAME="${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}-${GO_REVISION_DOCKER_}-rev${GO_PIPELINE_COUNTER}"
else
    export BUILD_IMG_NAME="${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}-${GO_REVISION}-rev${GO_PIPELINE_COUNTER}"
fi
echo ">> BUILD_IMG_NAME:${BUILD_IMG_NAME}"

if [ -d test ];then
    echo ">>>> Run test"
    cd test
    ./run.sh
fi
