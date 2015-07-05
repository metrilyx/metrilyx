SHELL=/bin/bash

NAME = metrilyx
VERSION = 3.0.0

BUILD_BASE_DIR = ./build
BUILD_DIR = ${BUILD_BASE_DIR}/${NAME}

FPM_MET_DEP_OPTS = -d 'metrilyx-dashboarder >= 3.0.0' -d gcc -d make -d python-setuptools -d git
FPM_MET_RPM_DEPS = -d 'python-twisted-core' -d 'numpy >= 1.7' -d libuuid -d python-devel -d gcc-g++ -d gcc-gfortran -d libffi-devel
FPM_MET_DEB_DEPS = -d 'python-twisted' -d 'python-numpy >= 1.7' -d libuuid1 -d python-dev -d g++ -d gfortran -d libffi-dev


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

.build: .clean .build_yum_repo .build_apt_repo

.repo_rpm:
	cd ${BUILD_DIR}/el && fpm -s dir -t rpm -d pygpgme -n ${NAME}-repo ./etc
	[ -d ${BUILD_BASE_DIR}/el ] || mkdir -p ${BUILD_BASE_DIR}/el
	mv ${BUILD_DIR}/el/*.rpm ${BUILD_BASE_DIR}/el/
  
.repo_deb:
	cd ${BUILD_DIR}/ubuntu && fpm -s dir -t deb -d apt-transport-https -n ${NAME}-repo ./etc
	[ -d ${BUILD_BASE_DIR}/ubuntu ] || mkdir -p ${BUILD_BASE_DIR}/ubuntu
	mv ${BUILD_DIR}/ubuntu/*.deb ${BUILD_BASE_DIR}/ubuntu/
  
.rpm:
	fpm -s dir -t rpm -n ${NAME} --version ${VERSION} ${FPM_MET_DEP_OPTS} ${FPM_MET_RPM_DEPS} ./etc
	[ -d ${BUILD_BASE_DIR}/el ] || mkdir -p ${BUILD_BASE_DIR}/el
	mv *.rpm ${BUILD_BASE_DIR}/el/

.deb:
	fpm -s dir -t deb -n ${NAME} --version ${VERSION} ${FPM_MET_DEP_OPTS} ${FPM_MET_DEB_DEPS} ./etc
	[ -d ${BUILD_BASE_DIR}/ubuntu ] || mkdir -p ${BUILD_BASE_DIR}/ubuntu
	mv *.deb ${BUILD_BASE_DIR}/ubuntu/

all: .build .repo_rpm .repo_deb .rpm .deb
