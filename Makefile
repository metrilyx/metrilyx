SHELL=/bin/bash

NAME = metrilyx
VERSION = 3.0.0

BUILD_BASE_DIR = ./build
BUILD_DIR = ${BUILD_BASE_DIR}/${NAME}

FPM_DEP_OPTS = -d 'metrilyx-dashboarder >= 3.0.0' -d 'metrilyx-dataserver >= 3.0.0'

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

.rpm:
  [ -d ${BUILD_BASE_DIR}/el ] || mkdir -p ${BUILD_BASE_DIR}/el
  cd ${BUILD_DIR}/el && fpm -d pygpgme ${FPM_DEP_OPTS} -t rpm -n ${NAME} --version ${VERSION} ../../${BUILD_DIR}/el
  
.deb:
  [ -d ${BUILD_BASE_DIR}/ubuntu ] || mkdir -p ${BUILD_BASE_DIR}/ubuntu
  cd ${BUILD_BASE_DIR}/ubuntu && fpm -d apt-transport-https ${FPM_DEP_OPTS} -t deb -n ${NAME} --version ${VERSION} ../../${BUILD_DIR}/ubuntu
  
all: .clean .build_yum_repo .build_apt_repo
