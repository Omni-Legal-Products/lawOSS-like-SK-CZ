#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/../scripts/lib.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/c.md" <<'EOF'
---
type: spis
title: KAS vec
status: aktívny
---
# body
type: not-this
EOF
[ "$(okf_fm_get "$tmp/c.md" type)" = "spis" ]   || { echo "type wrong"; exit 1; }
[ "$(okf_fm_get "$tmp/c.md" title)" = "KAS vec" ] || { echo "title wrong"; exit 1; }
[ -z "$(okf_fm_get "$tmp/c.md" missing)" ]      || { echo "missing should be empty"; exit 1; }
[ "$(OKF_TODAY=2026-06-18 okf_today)" = "2026-06-18" ] || { echo "today wrong"; exit 1; }
[ "$(okf_slug 'Nová Vec  X')" = "nova-vec-x" ]  || { echo "slug wrong: $(okf_slug 'Nová Vec  X')"; exit 1; }
[ "$(okf_sed_escape 'A&B|C')" = 'A\&B\|C' ] || { echo "sed_escape wrong: $(okf_sed_escape 'A&B|C')"; exit 1; }
echo "lib_test OK"
