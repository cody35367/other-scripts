#!/bin/bash

CHECK_REMOTE=false
if [ "$1" = "-m" ]; then
    CHECK_REMOTE=true
fi

# Define functions that will be sourced in subshells
FUNCTIONS='
get_remote_head() {
    git fetch &>/dev/null
    local remote=$(git remote | head -n1)
    if [ -n "$remote" ]; then
        git remote show "$remote" 2>/dev/null | grep "HEAD branch" | sed "s/.*: //" | xargs -I {} echo "$remote/{}"
    fi
}

show_refs_inline() {
    local name="$1"
    local ref="${2:-HEAD}"
    local tags=$(git tag --points-at "$ref" | tr "\n" " ")
    local branches=$(git branch --points-at "$ref" | tr "\n" " ")
    echo "$name ($ref): t: $tags b: $branches"
}

# Main script for git repos (used by foreach)
run_check() {
    if [ "$CHECK_REMOTE" = "true" ]; then
        remote_head=$(get_remote_head)
        show_refs_inline "$1" "${remote_head:-HEAD}"
    else
        show_refs_inline "$1" "HEAD"
    fi
}
'

export FUNCTIONS
export CHECK_REMOTE

if [ -d ".repo" ]; then
    # repo project
    repo forall -c 'eval "$FUNCTIONS"; run_check "$REPO_PATH"'
    
elif [ -d ".git" ]; then
    # git project
    eval "$FUNCTIONS"
    run_check $(basename "$PWD")
    
    # Check for submodules
    if [ -f ".gitmodules" ]; then
        git submodule foreach --quiet 'eval "$FUNCTIONS"; run_check "$displaypath"'
    fi
    
else
    echo "Error: Not a git or repo directory"
    exit 1
fi
