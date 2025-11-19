#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-}"
DEST="${2:-}"

if [[ -z "$MANIFEST" || -z "$DEST" ]]; then
    echo "Usage: $0 <manifest_file> <destination_root>"
    exit 1
fi

if [[ ! -f "$MANIFEST" ]]; then
    echo "Manifest file not found: $MANIFEST"
    exit 1
fi

mkdir -p "$DEST"
DEST="$(realpath "$DEST")"

while IFS= read -r line; do
    [[ "$line" =~ ^repo[[:space:]] ]] || continue

    # Parse manifest
    type=$(echo "$line" | awk '{print $1}')
    rel_path=$(echo "$line" | awk '{print $2}')
    url=$(echo "$line" | awk '{print $3}')

    # Convert from quoted string if needed
    eval rel_path="$rel_path"
    eval url="$url"

    target="$DEST/$rel_path"

    if [[ -d "$target/.git" ]]; then
        echo "Skipping existing repo: $rel_path"
        continue
    fi

    mkdir -p "$(dirname "$target")"
    echo "Cloning $url → $target"
    git clone "$url" "$target"

done < "$MANIFEST"
