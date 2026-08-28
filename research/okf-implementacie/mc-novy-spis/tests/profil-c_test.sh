#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; SC="$HERE/../scripts"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export OKF_TODAY=2026-07-13

# klient (real prerequisite for new-firma.sh: klient-dir must contain klient.md)
bash "$SC/new-klient.sh" "Acme Klient" --ico 11112222 --root "$tmp"
kd="$tmp/Acme Klient"

# new-firma: creates firma bundle with escaped values
bash "$SC/new-firma.sh" "Acme & Co (Acme s.r.o.)" --klient-dir "$kd" --ico 12345678 \
  --obchodne-meno "Acme & Co s.r.o." --spzn "Sro 1/V" --sud "Mestský súd Košice" --sidlo "Hlavná 1, Košice"
fd="$kd/Acme & Co (Acme s.r.o.)"
[ -f "$fd/spis.md" ] || { echo "new-firma: no spis.md"; exit 1; }
grep -q '^type: spis' "$fd/spis.md" || { echo "firma spis type"; exit 1; }
[ -f "$fd/CLAUDE.md" ] && [ ! -L "$fd/CLAUDE.md" ] || { echo "firma CLAUDE not copy"; exit 1; }
# no stray backslash from escaping anywhere in the card
grep -q '\\&' "$fd/spis.md" && { echo "stray backslash in firma card"; exit 1; }
# refuses existing (no-touch)
if bash "$SC/new-firma.sh" "Acme & Co (Acme s.r.o.)" --klient-dir "$kd" --ico 12345678 2>/dev/null; then
  echo "new-firma should refuse existing"; exit 1; fi

# new-kauza: subfolders vrátane Comms, vyžaduje spis.md vo firme, no-touch
bash "$SC/new-kauza.sh" "2 - Corporate" "2026-07 Zmena konateľa – zápis" --firma-dir "$fd"
kz="$fd/2 - Corporate/2026-07 Zmena konateľa – zápis"
for sub in "1 - Podklady od klienta" "7 - Súdne podania" "Comms s klientom" "Comms s protistranou"; do
  [ -d "$kz/$sub" ] || { echo "kauza missing: $sub"; exit 1; }
done
if bash "$SC/new-kauza.sh" "2 - Corporate" "2026-07 Zmena konateľa – zápis" --firma-dir "$fd" 2>/dev/null; then
  echo "new-kauza should refuse existing"; exit 1; fi
nofirma="$tmp/plain"; mkdir -p "$nofirma"
if bash "$SC/new-kauza.sh" "2 - Corporate" "x" --firma-dir "$nofirma" 2>/dev/null; then
  echo "new-kauza should require spis.md"; exit 1; fi

# validity of whole tree
bash "$SC/okf-validate.sh" "$fd" >/dev/null || { echo "firma tree not conformant"; exit 1; }

# write-back sekcie musia existovať aj vo firma _STATUS.md
for sec in 'Fáza:' 'Ďalší krok:' '## 2. Fakty veci' '## 7. Komunikácia'; do
  grep -qF "$sec" "$fd/_STATUS.md" || { echo "firma _STATUS missing: $sec"; exit 1; }
done
echo "profil-c_test OK"
