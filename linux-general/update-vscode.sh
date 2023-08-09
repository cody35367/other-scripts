#!/bin/bash

mkdir -vp ~/Applications ~/Downloads/installed
# Visual Studio Code
rm -rf ~/Applications/code/
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" -o ~/Downloads/installed/code.tar.gz
tar -xzf ~/Downloads/installed/code.tar.gz -C ~/Applications
cp -av "$(dirname "$0")/vscode.desktop" ~/.local/share/applications/
