#!/bin/bash
set -e

if [ "X${SKIP_BUILD_CHECK}" == "Xfalse" ];then
    /usr/local/bin/go-dckrimg check --tag ${DOCKER_TAG} --rev ${GO_PIPELINE_COUNTER}
fi
