SHELL=/bin/bash

NAME = metrilyx
VERSION = 3.0.0

BUILD_BASE_DIR = ./build
BUILD_DIR = ${BUILD_BASE_DIR}/${NAME}

FPM_MET_DEP_OPTS = -d 'metrilyx-dashboarder >= 3.0.0' -d 'metrilyx-dataserver >= 3.0.0'

REPO_URL_BASE = https://packagecloud.io/install/repositories/metrilyx/metrilyx
APT_REPO_DIR = ${BUILD_DIR}/ubuntu/etc/apt/sources.list.d
YUM_REPO_DIR = ${BUILD_DIR}/el/etc/yum.repos.d


.clean:
	rm -rf ${BUILD_BASE_DIR}

.build_yum_repo:
	[ -d ${YUM_REPO_DIR} ] || mkdir -p ${YUM_REPO_DIR}
	curl -s "${REPO_URL_BASE}/config_file.repo?os=el&dist=7&source=script" -o ${YUM_REPO_DIR}/metrilyx.repo

.build_apt_repo:
	[ -d ${APT_REPO_DIR} ] || mkdir -p ${APT_REPO_DIR}
	curl -s "${REPO_URL_BASE}/config_file.list?dist=trusty&os=ubuntu&source=script" -o ${APT_REPO_DIR}/metrilyx.list

.repo_rpm:
  [ -d ${BUILD_BASE_DIR}/el ] || mkdir -p ${BUILD_BASE_DIR}/el
  cd ${BUILD_DIR}/el && fpm -s dir -t rpm -d pygpgme -n ${NAME}-repo ../../${BUILD_DIR}/el
  
.repo_deb:
  [ -d ${BUILD_BASE_DIR}/ubuntu ] || mkdir -p ${BUILD_BASE_DIR}/ubuntu
  cd ${BUILD_BASE_DIR}/ubuntu && fpm -s dir -t deb -d apt-transport-https -n ${NAME}-repo ../../${BUILD_DIR}/ubuntu
  
.rpm:
	cd ${BUILD_BASE_DIR}/ubuntu && fpm -s dir -t rpm -n ${NAME} --version ${VERSION} ${FPM_MET_DEP_OPTS} ../../etc/init.d/metrilyx

.deb:
	cd ${BUILD_BASE_DIR}/ubuntu && fpm -s dir -t deb -n ${NAME} --version ${VERSION} ${FPM_MET_DEP_OPTS} ../../etc/init.d/metrilyx

all: .clean .build_yum_repo .build_apt_repo
