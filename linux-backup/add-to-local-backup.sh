#!/bin/bash
set -e

BACKUP_DIR=$HOME/.backup

function check_paths(){
    for path in "$@"
    do
        if [[ ! -e "${path}" ]]; then
            echo "'${path}' does not exists!"
            exit 1
        fi
    done
}

function add_symbolic_links(){
    mkdir -p ${BACKUP_DIR}
    for path in "$@"
    do
        full_path=$(realpath ${path})
        parent_dir=$(dirname ${full_path})
        mkdir -pv ${BACKUP_DIR}${parent_dir}
        ln -sv ${full_path} ${BACKUP_DIR}${full_path}
    done
}

check_paths "$@"
add_symbolic_links "$@"