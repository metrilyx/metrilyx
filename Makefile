SHELL=/bin/bash

NAME = metrilyx
VERSION = 3.0.0

REPO_URL_BASE = https://packagecloud.io/install/repositories/metrilyx/metrilyx

BUILD_BASE_DIR = ./build
BUILD_DIR = ${BUILD_BASE_DIR}/${NAME}

APT_REPO_DIR = ${BUILD_DIR}/ubuntu/etc/apt/sources.list.d
YUM_REPO_DIR = ${BUILD_DIR}/el/etc/yum.repos.d

.build_yum_repo:
  [ -d ${YUM_REPO_DIR} ] || mkdir -p ${YUM_REPO_DIR}
  curl -o ${YUM_REPO_DIR}/metrilyx.repo "${REPO_URL_BASE}?config_file.repo&dist=7&os=el"

.build_apt_repo:
  [ -d ${APT_REPO_DIR} ] || mkdir -p {$APT_REPO_DIR}
  curl -o ${APT_REPO_DIR}/metrilyx.list "${REPO_URL_BASE}?config_file.list&dist=trusty&os=ubuntu"

.rpm:
  [ -d ${BUILD_BASE_DIR}/el ] || mkdir -p ${BUILD_BASE_DIR}/el
  cd ${BUILD_DIR}/el && fpm -d pygpgme -t rpm -n ${NAME} --version ${VERSION} ../../${BUILD_DIR}/el
  
.deb:
  [ -d ${BUILD_BASE_DIR}/ubuntu ] || mkdir -p ${BUILD_BASE_DIR}/ubuntu
  cd ${BUILD_BASE_DIR}/ubuntu && fpm -d apt-transport-https -t deb -n ${NAME} --version ${VERSION} ../../${BUILD_DIR}/ubuntu
  
all: .build_yum_repo .build_apt_repo
