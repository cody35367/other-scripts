#!/bin/bash

cd "$(dirname "$0")"

RC_FILE=${HOME}/.zshrc
REPO_RC_FILE="$(realpath "./.zshrc")"

rm -v ${REPO_RC_FILE}

ln -v ${RC_FILE} ${REPO_RC_FILE}
