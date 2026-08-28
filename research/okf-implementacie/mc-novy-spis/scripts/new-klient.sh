#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
TPL="$HERE/../templates/klient"

name=""; ico=""; root="$PWD"
while [ $# -gt 0 ]; do case "$1" in
  --ico)  ico="$2";  shift 2;;
  --root) root="$2"; shift 2;;
  -*)     okf_die "unknown flag: $1";;
  *)      name="$1"; shift;;
esac; done
[ -n "$name" ] || okf_die "usage: new-klient.sh <Názov> [--ico ICO] [--root DIR]"

dest="$root/$name"          # keep human name verbatim — naming convention §2
[ -e "$dest" ] && okf_die "target exists, refusing (no-touch): $dest"
mkdir -p "$dest"

today="$(okf_today)"
fill() {
  local n i d
  n="$(okf_sed_escape "$name")"
  i="$(okf_sed_escape "$ico")"
  d="$(okf_sed_escape "$today")"
  sed -e "s|{{KLIENT}}|$n|g" \
      -e "s|{{KLIENT_ICO}}|$i|g" \
      -e "s|{{DESCRIPTION}}||g" \
      -e "s|{{DATE}}|$d|g" \
      "$1"
}

fill "$TPL/klient.md" > "$dest/klient.md"
fill "$TPL/AGENTS.md" > "$dest/AGENTS.md"
fill "$TPL/MEMORY.md" > "$dest/MEMORY.md"
cp "$dest/AGENTS.md" "$dest/CLAUDE.md"   # Profile A: byte copy (Drive mirror, spec §3.1)

bash "$HERE/index-gen.sh" "$root" >/dev/null
echo "created klient: $dest"
