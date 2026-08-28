#!/usr/bin/env bash
# new-kauza.sh — konkrétna kauza VNÚTRI korporátnej firmy (tematická oblasť 1–6).
# Vytvorí pracovné podpriečinky podľa konvencie spisu (1–7) + Comms v rámci kauzy.
# Kauza nemá vlastnú kartu — kartou je firma (firma = spis).
#
# Usage:
#   new-kauza.sh "<oblasť: napr. '2 - Corporate' alebo '2 - Corporate/Zmeny v spoločnosti'>" \
#                "<názov kauzy: YYYY-MM Vec – typ>" --firma-dir DIR
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"

oblast=""; nazov=""; firma_dir=""
while [ $# -gt 0 ]; do case "$1" in
  --firma-dir) firma_dir="$2"; shift 2;;
  -*) okf_die "unknown flag: $1";;
  *)  if [ -z "$oblast" ]; then oblast="$1"; else nazov="$1"; fi; shift;;
esac; done

[ -n "$oblast" ] && [ -n "$nazov" ] && [ -n "$firma_dir" ] \
  || okf_die 'usage: new-kauza.sh "<oblasť 1-6>" "<názov>" --firma-dir DIR'
[ -d "$firma_dir" ] || okf_die "firma-dir not found: $firma_dir"
[ -f "$firma_dir/spis.md" ] || okf_die "missing spis.md (toto nie je firma): $firma_dir"

dest="$firma_dir/$oblast/$nazov"
[ -e "$dest" ] && okf_die "target exists, refusing (no-touch): $dest"
mkdir -p \
  "$dest/1 - Podklady od klienta" \
  "$dest/2 - Drafty" \
  "$dest/3 - Research" \
  "$dest/4 - Iné" \
  "$dest/5 - Skeny | Podpísané dokumenty" \
  "$dest/6 - KEP-asice | Formuláre" \
  "$dest/7 - Súdne podania" \
  "$dest/Comms s klientom" \
  "$dest/Comms s protistranou"
echo "created kauza: $dest"

