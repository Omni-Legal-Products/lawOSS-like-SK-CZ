#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Y="$HERE/../scripts/sync_agents_claude.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
printf 'AGENTS body\n' > "$tmp/AGENTS.md"
bash "$Y" "$tmp"
cmp -s "$tmp/AGENTS.md" "$tmp/CLAUDE.md"         || { echo "copy mirror failed"; exit 1; }
bash "$Y" "$tmp" --symlink
[ -L "$tmp/CLAUDE.md" ]                          || { echo "symlink mode failed"; exit 1; }
echo "sync_test OK"
