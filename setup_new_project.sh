#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/Documents/research/code/my_projects/claude-code-my-workflow"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <new-folder-path>" >&2
    exit 1
fi

TARGET_DIR="$1"

if [[ -e "$TARGET_DIR" ]]; then
    echo "Error: '$TARGET_DIR' already exists." >&2
    exit 1
fi

mkdir -p "$TARGET_DIR"

for item in .claude claude_utilities programs templates CLAUDE.md initial_prompt.md; do
    src="$SOURCE_DIR/$item"
    if [[ ! -e "$src" ]]; then
        echo "Warning: '$src' not found, skipping." >&2
        continue
    fi
    cp -r "$src" "$TARGET_DIR/"
done

echo "Project initialized at: $TARGET_DIR"
