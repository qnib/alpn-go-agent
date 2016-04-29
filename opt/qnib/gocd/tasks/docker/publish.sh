#!/bin/bash
echo ">> Publish"
set -e

IMG_NAME=$(echo ${GO_PIPELINE_NAME} |awk -F'[\_\.]' '{print $1}')
if [ -z ${GO_REVISION} ];then
    export BUILD_IMG_NAME="${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}-${GO_REVISION_DOCKER_}-rev${GO_PIPELINE_COUNTER}"
else
    export BUILD_IMG_NAME="${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}-${GO_REVISION}-rev${GO_PIPELINE_COUNTER}"
fi
echo ">> BUILD_IMG_NAME:${BUILD_IMG_NAME}"


if [ "X${SKIP_TAG_LATEST}" != "Xtrue" ];then
    docker tag -f ${BUILD_IMG_NAME} ${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}
    if [ "X${DOCKER_REG}" != "X" ];then
      docker tag -f ${BUILD_IMG_NAME} ${DOCKER_REG}/${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}
      docker push ${DOCKER_REG}/${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}
      docker rmi ${DOCKER_REG}/${DOCKER_REPO-gaikai}/${IMG_NAME}:${DOCKER_TAG}
    fi
else
   echo ">> Skip tagging the build as ${DOCKER_TAG}"
fi

if [ "X${DOCKER_REG}" != "X" ];then
    docker tag -f ${BUILD_IMG_NAME} ${DOCKER_REG}/${BUILD_IMG_NAME}
    docker push ${DOCKER_REG}/${BUILD_IMG_NAME}
    docker rmi ${DOCKER_REG}/${BUILD_IMG_NAME}

else
   echo ">> Skip pushing to registry, since none set"
fi
docker rmi ${BUILD_IMG_NAME}
