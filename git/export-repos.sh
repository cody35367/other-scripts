#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
    echo "Usage: $0 <root_directory>"
    exit 1
fi

ROOT="$(realpath "$ROOT")"
cd "$ROOT"

# Find all .git directories
while IFS= read -r -d '' gitdir; do
    repo_path="$(dirname "$gitdir")"
    rel_path="$(realpath --relative-to="$ROOT" "$repo_path")"

    # Read the "origin" remote URL, fallback to first remote if needed
    url="$(git -C "$repo_path" remote get-url origin 2>/dev/null || true)"
    if [[ -z "$url" ]]; then
        url="$(git -C "$repo_path" remote get-url $(git -C "$repo_path" remote) 2>/dev/null || true)"
    fi
    if [[ -z "$url" ]]; then
        echo "WARNING: No remotes found for repo at $rel_path" >&2
        continue
    fi

    # Output manifest entry
    printf "repo %q %q\n" "$rel_path" "$url"

done < <(find "$ROOT" -type d -name .git -print0)
