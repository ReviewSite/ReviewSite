#!/bin/bash

apt-get -y install xvfb
Xvfb :1 -screen 0 1024x768x24 &
echo "export DISPLAY=:1" >> /etc/profile.d/bundle.sh