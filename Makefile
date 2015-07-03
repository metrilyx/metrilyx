SHELL=/bin/bash

NAME = metrilyx
VERSION = 3.0.0

BUILD_BASE_DIR = ./build
BUILD_DIR = ${BUILD_BASE_DIR}/${NAME}

.build_yum_repo:
  [ -d ${BUILD_DIR}/el/etc ] || mkdir -p ${BUILD_DIR}/el/etc
  cp -a etc/yum.repos.d ${BUILD_DIR}/el/etc/
  
.build_apt_repo:
  [ -d ${BUILD_DIR}/ubuntu/etc ] || mkdir -p ${BUILD_DIR}/ubuntu/etc
  cp -a etc/apt ${BUILD_DIR}/ubuntu/etc/

.rpm:
  [ -d ${BUILD_BASE_DIR}/el ] || mkdir -p ${BUILD_BASE_DIR}/el
  cd ${BUILD_DIR}/el && fpm -d pygpgme -t rpm -n ${NAME} --version ${VERSION} ../../${BUILD_DIR}/el
  
.deb:
  [ -d ${BUILD_BASE_DIR}/ubuntu ] || mkdir -p ${BUILD_BASE_DIR}/ubuntu
  cd ${BUILD_BASE_DIR}/ubuntu && fpm -d apt-transport-https -t deb -n ${NAME} --version ${VERSION} ../../${BUILD_DIR}/ubuntu
  
all: .build_yum_repo .build_apt_repo
