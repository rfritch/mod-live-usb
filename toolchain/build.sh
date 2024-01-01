#!/bin/bash

#######################################################################################################################
# exit if any command fails

set -e

#######################################################################################################################
# common setup

cd $(dirname ${0})
source ../.common.env

#######################################################################################################################
# create docker image for toolchain files

docker build --build-arg=GROUP_ID=$(id -g) --build-arg=USER_ID=$(id -u) -t mpb-toolchain .

#######################################################################################################################
# make sure workdir exists before we try to map it
echo $USER_ID
echo $USER

mkdir -p ${WORKDIR}/x86_64/build/crosstool-ng-1.25.0/build/tarballs
#mkdir -p ${WORKDIR}
cp  zlib-1.2.13.tar.gz  ${WORKDIR}/x86_64/build/crosstool-ng-1.25.0/build/tarballs/zlib-1.2.13.tar.gz 

#######################################################################################################################
# build the toolchain

docker run -v ${WORKDIR}:/home/builder/mod-workdir --rm mpb-toolchain:latest ./bootstrap.sh ${PLAT} toolchain

#######################################################################################################################
# cleanup crosstool-ng files, which can get quite big

rm -f ${WORKDIR}/download/crosstool-ng-1.25.0.tar.bz2

rm -rf ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0
mkdir ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0/.stamp_configured
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0/.stamp_built1
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0/.stamp_built2
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0/.stamp_patched
touch ${WORKDIR}/${PLAT}/build/crosstool-ng-1.25.0/configure

#######################################################################################################################
# mark as done

touch .stamp_built

#######################################################################################################################
