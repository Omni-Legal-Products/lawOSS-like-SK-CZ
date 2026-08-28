#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; SC="$HERE/../scripts"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export OKF_TODAY=2026-06-18
# Profile A
bash "$SC/new-klient.sh" "Austin Powder Slovakia, s.r.o." --ico 35868960 --root "$tmp"
kd="$tmp/Austin Powder Slovakia, s.r.o."
bash "$SC/new-spis.sh" "4 - Litigácie" "2025-08 KAS - vymáhanie - konkurz" --klient-dir "$kd" --protistrana "KAS, a.s."
# snapshot then add a second spis — first spis must be byte-identical (no-touch)
sum1="$(cksum "$kd/4 - Litigácie/2025-08 KAS - vymáhanie - konkurz/spis.md")"
bash "$SC/new-spis.sh" "2 - Corporate" "2026-01 Valné zhromaždenie" --klient-dir "$kd"
sum2="$(cksum "$kd/4 - Litigácie/2025-08 KAS - vymáhanie - konkurz/spis.md")"
[ "$sum1" = "$sum2" ] || { echo "NO-TOUCH VIOLATED"; exit 1; }
# Profile B
bash "$SC/new-projekt.sh" "Web relaunch" --root "$tmp"
# Conformance over the whole tree
bash "$SC/okf-validate.sh" "$tmp" >/dev/null || { echo "tree not conformant"; exit 1; }
echo "e2e_test OK"
