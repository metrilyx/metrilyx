# metrilyx


This project is used to build the repository rpm as well as a wrapper package dependent on other sub-components.

Requirements
------------

  * Centos/Oracle/RHEL 7, Ubuntu 14.04
  * Elasticsearch
  * Python >= 2.7

OS Packages
-----------
All required packages are available under the metrilyx repository.  The required packages are as follows:

 * python-pandas
 * python-opentsdb-pandas
 * metrilyx-dataserver
 * metrilyx-dashboarder

Installation
------------
The installation steps involve downloading the metrilyx package repository, followed by the package installation.

Enterprise Linux 7:

* Download repo. package:
    
    curl -L https://packagecloud.io/metrilyx/metrilyx/packages/el/7/metrilyx-repo-1.0-1.x86_64.rpm/download -o metrilyx-repo-1.0-1.x86_64.rpm

* Install repo. package:

    yum -y install metrilyx-repo-1.0-1.x86_64.rpm

* Install metrilyx:

    yum -y install metrilyx


Ubuntu 14.04:

* Download repo. package:

    curl -L https://packagecloud.io/metrilyx/metrilyx/packages/ubuntu/trusty/metrilyx-repo_1.0_amd64.deb/download -o metrilyx-repo_1.0_amd64.deb

* Install repo. package:

    dpkg -i metrilyx-repo_1.0_amd64.deb
    
* Install metrilyx:

    apt-get -y install metrilyx
