#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/Documents/research/code/my_projects/claude-code-my-workflow"
THEORIST_DIR="$HOME/Documents/research/code/my_projects/theorist-toolbox"

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

for item in .claude claude_utilities claude_tasks programs templates CLAUDE.md ; do
    src="$SOURCE_DIR/$item"
    if [[ ! -e "$src" ]]; then
        echo "Warning: '$src' not found, skipping." >&2
        continue
    fi
    cp -r "$src" "$TARGET_DIR/"
done

# --- Theorist Toolbox integration -------------------------------------------
# Pull in the agents, skills, and docs from theorist-toolbox so a new project
# has the theory/proof workflow available. Every file gets a "theorist-" prefix
# so it is immediately distinguishable as theorist tooling.
#
# Naming rules (differ by artifact because Claude Code keys them differently):
#   * Agents  -> prefix the FILENAME only. Agents are keyed by their frontmatter
#                `name:`, and the co-math agents dispatch each other by bare name
#                (prover, coder, lean-prover, ...). Renaming the names would break
#                that dispatch graph, so we leave `name:` untouched and only
#                prefix the file on disk.
#   * Skills  -> prefix BOTH the directory and the frontmatter `name:`. A skill's
#                invocation name is its `name:`, which must match its directory.
#                Prefixing also avoids collisions (e.g. theorist `math-proof` vs a
#                global `math-proof` skill). Invocation becomes /theorist-<name>.
#   * Docs    -> prefix the FILENAME; land them in .claude/references/ (this
#                repo's reference-doc directory; top-level docs/ is Pages output).
if [[ -d "$THEORIST_DIR" ]]; then
    mkdir -p "$TARGET_DIR/.claude/agents" \
             "$TARGET_DIR/.claude/skills" \
             "$TARGET_DIR/.claude/references"

    # Agents: prefix filename, preserve frontmatter name.
    if [[ -d "$THEORIST_DIR/agents" ]]; then
        for f in "$THEORIST_DIR"/agents/*.md; do
            [[ -e "$f" ]] || continue
            cp "$f" "$TARGET_DIR/.claude/agents/theorist-$(basename "$f")"
        done
    fi

    # Skills: prefix directory and frontmatter name.
    if [[ -d "$THEORIST_DIR/skills" ]]; then
        for d in "$THEORIST_DIR"/skills/*/; do
            [[ -d "$d" ]] || continue
            name="$(basename "$d")"
            dest="$TARGET_DIR/.claude/skills/theorist-$name"
            cp -r "$d" "$dest"
            # Rewrite the frontmatter `name:` line to match the new directory.
            for sf in "$dest"/SKILL.md "$dest"/skill.md; do
                [[ -f "$sf" ]] || continue
                perl -0pi -e "s/^name:[ \t]*\\Q$name\\E[ \t]*\$/name: theorist-$name/m" "$sf"
            done
        done
    fi

    # Docs: prefix filename, place in .claude/references/.
    if [[ -d "$THEORIST_DIR/docs" ]]; then
        for f in "$THEORIST_DIR"/docs/*.md; do
            [[ -e "$f" ]] || continue
            cp "$f" "$TARGET_DIR/.claude/references/theorist-$(basename "$f")"
        done
    fi

    echo "Theorist Toolbox integrated (theorist- prefix) from: $THEORIST_DIR"
else
    echo "Warning: theorist-toolbox not found at '$THEORIST_DIR', skipping." >&2
fi

echo "Project initialized at: $TARGET_DIR"
