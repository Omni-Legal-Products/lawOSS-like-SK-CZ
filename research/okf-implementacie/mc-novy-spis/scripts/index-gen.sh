#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
root="${1:?usage: index-gen.sh <dir>}"
out="$root/index.md"
{
  echo "# Obsah — $(basename "$root")"
  echo
  for card in "$root"/*/klient.md "$root"/*/spis.md "$root"/*/projekt.md; do
    [ -e "$card" ] || continue
    st="$(okf_fm_get "$card" status)"
    case "$st" in archív|ukončený) continue;; esac
    title="$(okf_fm_get "$card" title)"
    desc="$(okf_fm_get "$card" description)"
    rel="$(basename "$(dirname "$card")")/$(basename "$card")"
    printf -- '- [%s](%s) — %s (%s)\n' "$title" "$rel" "$desc" "$st"
  done
} > "$out"
echo "generated: $out"
