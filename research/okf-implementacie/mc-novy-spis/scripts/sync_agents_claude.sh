#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
root="${1:-.}"; mode="copy"
[ "${2:-}" = "--symlink" ] && mode="symlink"
[ "${1:-}" = "--symlink" ] && { mode="symlink"; root="."; }
find "$root" -name AGENTS.md | while IFS= read -r a; do
  d="$(dirname "$a")"; c="$d/CLAUDE.md"
  if [ "$mode" = "symlink" ]; then
    rm -f "$c"; ( cd "$d" && ln -s AGENTS.md CLAUDE.md )
  else
    if [ ! -e "$c" ] || [ "$a" -nt "$c" ]; then cp "$a" "$c";
    elif [ "$c" -nt "$a" ]; then cp "$c" "$a"; fi
  fi
done
echo "synced AGENTS↔CLAUDE under $root ($mode)"
