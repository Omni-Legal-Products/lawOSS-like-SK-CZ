#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
TPL="$HERE/../templates/projekt"

name=""; klient=""; root="$PWD"
while [ $# -gt 0 ]; do case "$1" in
  --klient) klient="$2"; shift 2;;
  --root) root="$2"; shift 2;;
  -*) okf_die "unknown flag: $1";;
  *) name="$1"; shift;;
esac; done
[ -n "$name" ] || okf_die "usage: new-projekt.sh <názov> [--klient X] [--root DIR]"

slug="$(okf_slug "$name")"
dest="$root/$slug"
[ -e "$dest" ] && okf_die "target exists, refusing (no-touch): $dest"
mkdir -p "$dest"/{docs,research,assets,drafty,_tools}

today="$(okf_today)"
fill() {
  local t k d
  t="$(okf_sed_escape "$name")"; k="$(okf_sed_escape "$klient")"; d="$(okf_sed_escape "$today")"
  sed -e "s|{{TITLE}}|$t|g" -e "s|{{DESCRIPTION}}||g" \
      -e "s|{{KLIENT}}|$k|g" -e "s|{{DATE}}|$d|g" "$1"
}
fill "$TPL/projekt.md" > "$dest/projekt.md"
fill "$TPL/AGENTS.md"  > "$dest/AGENTS.md"
fill "$TPL/MEMORY.md"  > "$dest/MEMORY.md"
ln -s AGENTS.md "$dest/CLAUDE.md"   # local symlink mirror (spec §3.1)

echo "created projekt: $dest"
