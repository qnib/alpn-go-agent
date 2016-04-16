#!/bin/bash
set -e

if [ -d docker ];then
    if [ -d build_src ];then
        echo ">> cp -r build_src docker/"
        cp -r build_src docker/
    fi
    cd docker
fi


if [ -x prebuild.sh ];then
    echo ">>>> Run prebuild script"
    ./prebuild.sh
fi
