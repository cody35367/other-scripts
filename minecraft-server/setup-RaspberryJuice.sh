#!/bin/bash

set -e

cd "$(dirname "$0")"

if [[ ! -d RaspberryJuice/ ]]; then
    git clone https://github.com/zhuowei/RaspberryJuice.git
fi

cd RaspberryJuice/

if ! which mvn; then
    sudo dnf install -y maven
fi

mvn package

cp ./jars/raspberryjuice-1.12.1.jar ../craftbukkit/plugins/
