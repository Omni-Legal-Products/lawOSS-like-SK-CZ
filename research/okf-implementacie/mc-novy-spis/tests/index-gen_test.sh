#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="$HERE/../scripts/index-gen.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/spisA" "$tmp/spisB"
printf -- '---\ntype: spis\ntitle: Vec A\ndescription: prvá\nstatus: aktívny\n---\n' > "$tmp/spisA/spis.md"
printf -- '---\ntype: spis\ntitle: Vec B\ndescription: druhá\nstatus: ukončený\n---\n' > "$tmp/spisB/spis.md"
bash "$G" "$tmp"
[ -f "$tmp/index.md" ]                          || { echo "no index"; exit 1; }
[ "$(head -n1 "$tmp/index.md")" != "---" ]      || { echo "index must have no frontmatter"; exit 1; }
grep -q 'Vec A' "$tmp/index.md"                 || { echo "active missing"; exit 1; }
grep -q 'Vec B' "$tmp/index.md"                 && { echo "ukončený should be skipped"; exit 1; }
echo "index-gen_test OK"
