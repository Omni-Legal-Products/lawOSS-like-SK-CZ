#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
TPL="$HERE/../templates/spis"

oblast=""; nazov=""; klient_dir=""; protistrana=""; ico=""; pico=""
while [ $# -gt 0 ]; do case "$1" in
  --klient-dir)     klient_dir="$2";    shift 2;;
  --protistrana)    protistrana="$2";   shift 2;;
  --ico)            ico="$2";           shift 2;;
  --protistrana-ico) pico="$2";         shift 2;;
  -*)               okf_die "unknown flag: $1";;
  *)  if [ -z "$oblast" ]; then oblast="$1"; else nazov="$1"; fi; shift;;
esac; done

[ -n "$oblast" ] && [ -n "$nazov" ] && [ -n "$klient_dir" ] \
  || okf_die "usage: new-spis.sh <oblasť> \"<YYYY-MM Protistrana - Vec - typ>\" --klient-dir DIR [--protistrana X] [--ico X] [--protistrana-ico X]"
[ -d "$klient_dir" ] || okf_die "klient-dir not found: $klient_dir"

klient="$(okf_fm_get "$klient_dir/klient.md" title)"
[ -n "$klient" ] || okf_die "could not read title from $klient_dir/klient.md"
[ -n "$ico" ] || ico="$(okf_fm_get "$klient_dir/klient.md" ico)"

dest="$klient_dir/$oblast/$nazov"
[ -e "$dest" ] && okf_die "target exists, refusing (no-touch): $dest"
mkdir -p "$dest"
mkdir -p \
  "$dest/1 - Podklady od klienta" \
  "$dest/2 - Drafty" \
  "$dest/3 - Research" \
  "$dest/4 - Iné" \
  "$dest/5 - Skeny | Podpísané dokumenty" \
  "$dest/6 - KEP-asice | Formuláre" \
  "$dest/7 - Súdne podania"

today="$(okf_today)"
fill() {
  local t k i p pi o d
  t="$(okf_sed_escape "$nazov")"
  k="$(okf_sed_escape "$klient")"
  i="$(okf_sed_escape "$ico")"
  p="$(okf_sed_escape "$protistrana")"
  pi="$(okf_sed_escape "$pico")"
  o="$(okf_sed_escape "$oblast")"
  d="$(okf_sed_escape "$today")"
  sed -e "s|{{TITLE}}|$t|g" \
      -e "s|{{DESCRIPTION}}||g" \
      -e "s|{{RESOURCE}}||g" \
      -e "s|{{KLIENT}}|$k|g" \
      -e "s|{{KLIENT_ICO}}|$i|g" \
      -e "s|{{PROTISTRANA}}|$p|g" \
      -e "s|{{PROTISTRANA_ICO}}|$pi|g" \
      -e "s|{{OBLAST}}|$o|g" \
      -e "s|{{SPZN}}||g" \
      -e "s|{{SUD}}||g" \
      -e "s|{{DATE}}|$d|g" \
      "$1"
}

fill "$TPL/spis.md"    > "$dest/spis.md"
fill "$TPL/_STATUS.md" > "$dest/_STATUS.md"
fill "$TPL/AGENTS.md"  > "$dest/AGENTS.md"
fill "$TPL/MEMORY.md"  > "$dest/MEMORY.md"
cp "$dest/AGENTS.md" "$dest/CLAUDE.md"   # Profile A: byte copy (Drive mirror, spec §3.1)

bash "$HERE/index-gen.sh" "$klient_dir" >/dev/null
echo "created spis: $dest"
