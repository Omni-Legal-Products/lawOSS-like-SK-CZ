#!/usr/bin/env bash
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"
root="${1:-.}"
[ -d "$root" ] || okf_die "not a dir: $root"
root="$(cd "$root" && pwd)"
errs=0

has_frontmatter() { [ "$(head -n1 "$1")" = "---" ]; }

while IFS= read -r f; do
  base="$(basename "$f")"
  if [ "$base" = "index.md" ]; then
    if has_frontmatter "$f"; then
      # allowed only at root and only okf_version
      if [ "$(dirname "$f")" = "$root" ]; then
        bad="$(awk 'NR==1&&$0=="---"{i=1;next} i&&$0=="---"{exit} i&&$0!~"^okf_version[[:space:]]*:"&&$0!~"^[[:space:]]*$"{print}' "$f")"
        [ -z "$bad" ] || { echo "ERROR: $f — root index.md may only carry okf_version"; errs=$((errs+1)); }
      else
        echo "ERROR: $f — index.md must not have frontmatter (reserved listing)"; errs=$((errs+1))
      fi
    fi
    continue
  fi
  [ "$base" = "log.md" ] && continue
  if ! has_frontmatter "$f" || [ -z "$(okf_fm_get "$f" type)" ]; then
    echo "ERROR: $f — concept document missing non-empty 'type:'"; errs=$((errs+1))
  fi
done < <(find "$root" -name '*.md' -not -path '*/templates/*')

[ "$errs" -eq 0 ] && echo "OK: $root conformant (OKF v0.1)"
[ "$errs" -eq 0 ]
