#!/bin/bash

cd "$(dirname "$0")"

RC_D_DIR="${HOME}/.bashrc.d/"

mkdir -p "${RC_D_DIR}"

for rc in ./bashrc.d/*; do
    if [ -f "$rc" ]; then
        ln -v "$(realpath "$rc")" "${RC_D_DIR}"
    fi
done