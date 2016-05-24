#!/bin/bash
echo ">> Publish"
set -xe

source /opt/qnib/gocd/helpers/gocd-functions.sh
# Create BUILD_IMG_NAME, which includes the git-hash and the revision of the pipeline
assemble_build_img_name


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
