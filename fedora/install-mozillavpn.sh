#!/bin/bash

sudo dnf install libcap-devel \
                    libsecret-devel \
                    wireguard-tools \
                    cmake \
                    qt6-qtbase \
                    qt6-qtbase-devel \
                    qt6-qtwebsockets-devel \
                    qt6-qtnetworkauth-devel \
                    qt6-qtquickcontrols2-devel \
                    qt6-qtcharts-devel \
                    qt6-qtbase-devel \
                    qt6-linguist \
                    polkit-libs \
                    polkit-devel \
                    golang \
                    qt6-qtsvg-devel \
                    cargo \
                    python3-jinja2 \
                    python3-pip \
                    qt6-qtbase-private-devel \
                    qt6-qt5compat

pip3 install --user glean-parser

cd ${HOME}/repos
git clone https://github.com/mozilla-mobile/mozilla-vpn-client.git
cd mozilla-vpn-client
#git tag --list
git checkout v2.21.0
git submodule init
git submodule update
cd ./3rdparty/sentry
git submodule init
git submodule update
cd ../..

mkdir build
cmake -S . -B build
cmake --build build -j$(nproc)
sudo cmake --install build
#cat build/install_manifest.txt
