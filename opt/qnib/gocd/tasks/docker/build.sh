#!/bin/bash
set -e
echo ">> BUILD"

source /opt/qnib/gocd/helpers/gocd-functions.sh


# Create BUILD_IMG_NAME, which includes the git-hash and the revision of the pipeline
assemble_build_img_name

# figure out information about the parent
query_parent

if [ -d docker ];then
    cd docker
fi

add_reg_to_dockerfile

build_dockerfile
