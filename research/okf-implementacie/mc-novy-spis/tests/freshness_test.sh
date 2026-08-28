#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; SC="$HERE/../scripts"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# fresh spis: _STATUS newest → OK
s1="$tmp/spis-fresh"; mkdir -p "$s1/2 - Drafty"
printf 'doc\n' > "$s1/2 - Drafty/a.pdf"
sleep 1
printf -- '---\ntype: status\n---\nstatus\n' > "$s1/_STATUS.md"
bash "$SC/okf-freshness.sh" "$s1" || { echo "fresh spis flagged stale"; exit 1; }

# stale spis: document newer than _STATUS → exit 1 + STALE line
s2="$tmp/spis-stale"; mkdir -p "$s2/2 - Drafty"
printf -- '---\ntype: status\n---\nstatus\n' > "$s2/_STATUS.md"
sleep 1
printf 'novy draft\n' > "$s2/2 - Drafty/b.pdf"
out="$(bash "$SC/okf-freshness.sh" "$s2" 2>&1)" && { echo "stale spis not flagged"; exit 1; }
printf '%s\n' "$out" | grep -q 'STALE:' || { echo "no STALE line"; exit 1; }

# control files do not trigger staleness (CLAUDE.md newer than _STATUS is fine)
s3="$tmp/spis-ctrl"; mkdir -p "$s3"
printf -- '---\ntype: status\n---\ns\n' > "$s3/_STATUS.md"
sleep 1
printf -- '---\ntype: agents\n---\na\n' > "$s3/CLAUDE.md"
bash "$SC/okf-freshness.sh" "$s3" || { echo "control file wrongly triggers stale"; exit 1; }

# nested: klient with one fresh and one stale spis → exit 1, STALE names the right one
k="$tmp/Klient X"; mkdir -p "$k/4 - Lit/vecA/2 - Drafty" "$k/4 - Lit/vecB/2 - Drafty"
printf 'd\n' > "$k/4 - Lit/vecA/2 - Drafty/a.pdf"; sleep 1
printf -- '---\ntype: status\n---\nA\n' > "$k/4 - Lit/vecA/_STATUS.md"     # A fresh
printf -- '---\ntype: status\n---\nB\n' > "$k/4 - Lit/vecB/_STATUS.md"; sleep 1
printf 'd\n' > "$k/4 - Lit/vecB/2 - Drafty/b.pdf"                          # B stale
out="$(bash "$SC/okf-freshness.sh" "$k" 2>&1)" && { echo "nested stale not flagged"; exit 1; }
printf '%s\n' "$out" | grep -q 'vecB' || { echo "wrong spis flagged: $out"; exit 1; }
printf '%s\n' "$out" | grep -q 'vecA' && { echo "fresh spis wrongly flagged"; exit 1; }

# ancestor with own _STATUS.md must NOT swallow a nested stale spis
kz="$tmp/Klient Z"; mkdir -p "$kz/4 - Lit/spisA/2 - Drafty"
printf -- '---\ntype: status\n---\nK\n' > "$kz/_STATUS.md"
printf -- '---\ntype: status\n---\nA\n' > "$kz/4 - Lit/spisA/_STATUS.md"
sleep 1
printf 'novy dokument\n' > "$kz/4 - Lit/spisA/2 - Drafty/novy.pdf"
out="$(bash "$SC/okf-freshness.sh" "$kz" 2>&1)" && { echo "ancestor swallowed nested stale"; exit 1; }
printf '%s\n' "$out" | grep -q 'spisA' || { echo "STALE line missing spisA: $out"; exit 1; }

echo "freshness_test OK"
