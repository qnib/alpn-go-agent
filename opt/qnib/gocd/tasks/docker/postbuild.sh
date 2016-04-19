#!/bin/bash
set -e

mkdir -p binpkg

if [ -d docker ];then
    DOCKER_DIR=true
fi


if [ -x postbuild.sh ];then
    echo ">>>> Run postbuild script"
    if [ -d docker ];then
        ./docker/postbuild.sh
    else
        ./postbuild.sh
    fi
fi
