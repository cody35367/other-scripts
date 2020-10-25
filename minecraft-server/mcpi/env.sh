#!/bin/bash

set -e

cd "$(dirname "$0")"
if [[ ! -d ./env/ ]];then
    python3 -m venv ./env/
fi

. ./env/bin/activate
pip install --upgrade pip
pip install mcpi

echo
echo "Run 'source ./env/bin/activate' in bash or"
echo "'source ./env/bin/activate.fish' in fish."
