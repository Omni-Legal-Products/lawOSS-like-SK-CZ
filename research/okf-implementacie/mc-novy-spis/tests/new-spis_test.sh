#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
K="$HERE/../scripts/new-klient.sh"; S="$HERE/../scripts/new-spis.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

OKF_TODAY=2026-06-18 bash "$K" "Austin Powder Slovakia, s.r.o." --ico 35868960 --root "$tmp"
kd="$tmp/Austin Powder Slovakia, s.r.o."
[ -f "$kd/klient.md" ]                          || { echo "no klient.md"; exit 1; }
grep -q '^type: klient'      "$kd/klient.md"     || { echo "klient type"; exit 1; }
grep -q 'ico: "35868960"'    "$kd/klient.md"     || { echo "ico"; exit 1; }
[ -f "$kd/CLAUDE.md" ] && [ ! -L "$kd/CLAUDE.md" ] || { echo "CLAUDE must be copy on Profile A"; exit 1; }
cmp -s "$kd/AGENTS.md" "$kd/CLAUDE.md"           || { echo "mirror not identical"; exit 1; }

OKF_TODAY=2026-06-18 bash "$S" "4 - Litigácie" "2025-08 KAS - vymáhanie - konkurz" \
  --klient-dir "$kd" --protistrana "Kameňolomy a štrkopieskovne, a.s."
sd="$kd/4 - Litigácie/2025-08 KAS - vymáhanie - konkurz"
[ -f "$sd/spis.md" ] && [ -f "$sd/_STATUS.md" ] || { echo "spis files"; exit 1; }
grep -q '^type: spis' "$sd/spis.md"             || { echo "spis type"; exit 1; }
grep -q 'protistrana: Kameňolomy' "$sd/spis.md" || { echo "protistrana"; exit 1; }
[ -d "$sd/1 - Podklady od klienta" ] && [ -d "$sd/7 - Súdne podania" ] || { echo "subfolders 1-7"; exit 1; }

# Regression: special chars (&, ,) must appear LITERALLY in spis.md
grep -qF 'Kameňolomy a štrkopieskovne, a.s.' "$sd/spis.md" || { echo "REGRESSION: special chars in protistrana corrupted"; exit 1; }

bash "$HERE/../scripts/okf-validate.sh" "$kd" >/dev/null || { echo "not conformant"; exit 1; }

# write-back protokol: nové sekcie v _STATUS.md a protokol v AGENTS.md
grep -q '^## 2. Fakty veci' "$sd/_STATUS.md"        || { echo "missing Fakty veci"; exit 1; }
grep -q '^## 7. Komunikácia' "$sd/_STATUS.md"        || { echo "missing Komunikácia"; exit 1; }
grep -q 'Fáza:' "$sd/_STATUS.md"                     || { echo "missing Fáza"; exit 1; }
grep -q 'Ďalší krok:' "$sd/_STATUS.md"               || { echo "missing Ďalší krok"; exit 1; }
grep -qF '<!-- okf:protokol-zapisu:v1 -->' "$sd/AGENTS.md" || { echo "missing protokol marker in AGENTS"; exit 1; }
grep -q 'PROTOKOL ZÁPISU' "$sd/CLAUDE.md"            || { echo "protokol not mirrored to CLAUDE"; exit 1; }

echo "new-spis_test OK"
