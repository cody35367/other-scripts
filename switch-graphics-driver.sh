#!/bin/bash

set -e

NVIDIA_DRIVER_PACKAGE="nvidia-driver-415"
NVIDIA_CHECK_FOR_BINARY="nvidia-smi"
NVIDIA_FOUND_STR="The proprietary NVIDIA driver is install!"
NVIDIA_NOT_FOUND_STR="The proprietary NVIDIA driver was NOT found!"
INSTALL_NVIDIA_PROMPT="Do you want to install the proprietary NVIDIA driver? (Y/N): "
REMOVE_NVIDIA_PROMPT="Do you want to remove the proprietary NVIDIA driver? (Y/N): "

function install_nvidia(){
    sudo apt-get update
    sudo apt-get install ${NVIDIA_DRIVER_PACKAGE} -y
}

function remove_nvidia(){
    sudo apt-get update
    sudo apt-get remove ${NVIDIA_DRIVER_PACKAGE} -y
    sudo apt-get autoremove -y
}

if [ $(which ${NVIDIA_CHECK_FOR_BINARY}) ]; then
    echo ${NVIDIA_FOUND_STR}
    read -p "${REMOVE_NVIDIA_PROMPT}" -n 1 -r yn
    echo
    case $yn in
        [Yy] ) remove_nvidia;;
    esac
else
    echo ${NVIDIA_NOT_FOUND_STR}
    read -p "${INSTALL_NVIDIA_PROMPT}" -n 1 -r yn
    echo
    case $yn in
        [Yy] ) install_nvidia;;
    esac
fi
