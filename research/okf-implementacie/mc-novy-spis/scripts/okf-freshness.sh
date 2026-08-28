#!/usr/bin/env bash
# okf-freshness.sh <dir> — drift detektor: pre KAŽDÝ _STATUS.md pod <dir>
# (vrátane <dir> samotného) porovná jeho mtime s najnovším mtime "content"
# súborov v jeho VLASTNOM podstrome (bez podstromov vnorených _STATUS.md).
#
# Content súbor = každý bežný súbor okrem kontrolných súborov na KORENI
# daného adresára (_STATUS.md, AGENTS.md, CLAUDE.md, MEMORY.md, spis.md,
# klient.md, projekt.md, index.md, log.md) a okrem .DS_Store kdekoľvek.
#
# Exit 0 + "OK: žiadny drift" ak nič nie je stale.
# Exit 1 + "STALE: <dir> — _STATUS.md je starší než: <relatívna cesta>" pre
# každý stale spis.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"

root="${1:-}"
[ -n "$root" ] && [ -d "$root" ] || okf_die "usage: okf-freshness.sh <dir>"
root="$(cd "$root" && pwd)"

CONTROL_FILES="_STATUS.md AGENTS.md CLAUDE.md MEMORY.md spis.md klient.md projekt.md index.md log.md"

is_control_file() {
  # $1 = basename
  local b="$1" cf
  for cf in $CONTROL_FILES; do
    [ "$b" = "$cf" ] && return 0
  done
  return 1
}

stale_count=0

# všetky _STATUS.md pod root (vrátane root/_STATUS.md, ak existuje)
status_files="$(find "$root" -name _STATUS.md -type f)"

# zoznam adresárov, ktoré majú _STATUS.md (na detekciu vnorených hraníc)
status_dirs="$(printf '%s\n' "$status_files" | while IFS= read -r sf; do
  [ -n "$sf" ] && dirname "$sf"
done)"

while IFS= read -r sf; do
  [ -n "$sf" ] || continue
  d="$(dirname "$sf")"
  status_mtime="$(stat -f '%m' "$sf" 2>/dev/null)" || continue

  newest_mtime=0
  newest_rel=""

  while IFS= read -r f; do
    [ -n "$f" ] || continue
    base="$(basename "$f")"
    [ "$base" = ".DS_Store" ] && continue

    fdir="$(dirname "$f")"
    # skip control files that live at the ROOT of this spis (fdir == d)
    if [ "$fdir" = "$d" ] && is_control_file "$base"; then
      continue
    fi

    # skip files that belong to a NESTED dir that has its own _STATUS.md
    skip=0
    while IFS= read -r sd; do
      [ -n "$sd" ] || continue
      # only status dirs that are STRICT DESCENDANTS of d are valid
      # exclusion boundaries; d itself, ancestors, or siblings are not.
      case "$sd" in
        "$d"/*) : ;;
        *) continue ;;
      esac
      case "$fdir" in
        "$sd"|"$sd"/*) skip=1; break;;
      esac
    done <<EOF_SD
$status_dirs
EOF_SD
    [ "$skip" -eq 1 ] && continue

    mt="$(stat -f '%m' "$f" 2>/dev/null)" || continue
    if [ "$mt" -gt "$newest_mtime" ]; then
      newest_mtime="$mt"
      newest_rel="${f#"$d"/}"
    fi
  done < <(find "$d" -type f)

  if [ -n "$newest_rel" ] && [ "$newest_mtime" -gt "$status_mtime" ]; then
    echo "STALE: $d — _STATUS.md je starší než: $newest_rel"
    stale_count=$((stale_count + 1))
  fi
done <<EOF_SF
$status_files
EOF_SF

if [ "$stale_count" -eq 0 ]; then
  echo "OK: žiadny drift"
  exit 0
fi
exit 1
