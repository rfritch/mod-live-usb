#!/bin/bash

#######################################################################################################################
# exit if any command fails

set -e

cd $(dirname ${0})

#######################################################################################################################
# environment variables

PLAT=${PLAT:=x86_64}
WORKDIR=${WORKDIR:=$(pwd)/mod-workdir}

#######################################################################################################################
# create docker image for toolchain files

docker build --build-arg=GROUP_ID=$(id -g) --build-arg=USER_ID=$(id -u) -t mpb-toolchain .

#######################################################################################################################
# make sure workdir exists before we try to map it

mkdir -p ${WORKDIR}

#######################################################################################################################
# build the toolchain

docker run -v ${WORKDIR}:/home/builder/mod-workdir --rm mpb-toolchain:latest ./bootstrap.sh ${PLAT} toolchain

#######################################################################################################################
# cleanup crosstool-ng files, which can get quite big

rm -f ${WORKDIR}/download/crosstool-ng-1.24.0.tar.bz2

rm -rf ${WORKDIR}/${PLAT}/build/crosstool-ng-1.24.0
mkdir ${WORKDIR}/${PLAT}/build/crosstool-ng-1.24.0
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.24.0/.stamp_configured
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.24.0/.stamp_built1
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.24.0/.stamp_built2
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.24.0/configure

#######################################################################################################################
# mark as done

touch .stamp_built

#######################################################################################################################
