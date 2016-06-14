#!/bin/bash

cd /tmp
wget "https://launchpad.net/~ubuntu-mozilla-security/+archive/ubuntu/ppa/+build/9298742/+files/firefox_45.0+build2-0ubuntu0.14.04.1_amd64.deb"
dpkg -i firefox_45.0+build2-0ubuntu0.14.04.1_amd64.deb
apt-mark hold firefox
apt-get -f -y install
