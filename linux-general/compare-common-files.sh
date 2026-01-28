#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <dir1> <dir2>"
    exit 1
fi

DIR1=$(realpath "$1")
DIR2=$(realpath "$2")

# Find all regular files in dir1, store relative paths
while IFS= read -r -d '' file1; do
    rel="${file1#$DIR1/}"
    file2="$DIR2/$rel"

    if [[ -f "$file2" ]]; then
        echo "FOUND: $rel"

        if ! diff -q "$file1" "$file2" >/dev/null; then
            echo "  DIFFER: $rel"
        fi
    fi
done < <(find "$DIR1" -type f -print0)