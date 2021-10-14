#!/bin/bash
yum install curl gpg gcc gcc-c++ make patch autoconf automake bison libffi-devel libtool patch readline-devel sqlite-devel zlib-devel openssl-devel -y
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.5.1
yum update -y
gem install morpheus-cli