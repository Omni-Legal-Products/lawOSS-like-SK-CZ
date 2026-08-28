#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
S="$HERE/../scripts/new-projekt.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

OKF_TODAY=2026-06-18 bash "$S" "HITL kampaň Q3" --klient "Acme s.r.o." --root "$tmp"
d="$tmp/hitl-kampan-q3"
[ -f "$d/projekt.md" ]                                  || { echo "no projekt.md"; exit 1; }
grep -q '^type: projekt'        "$d/projekt.md"         || { echo "type wrong"; exit 1; }
grep -q 'klient: Acme s.r.o.'   "$d/projekt.md"         || { echo "klient wrong"; exit 1; }
grep -q 'timestamp: 2026-06-18' "$d/projekt.md"         || { echo "date wrong"; exit 1; }
[ -L "$d/CLAUDE.md" ]                                   || { echo "CLAUDE not symlink"; exit 1; }
for sub in docs research assets drafty _tools; do [ -d "$d/$sub" ] || { echo "missing subdir: $sub"; exit 1; }; done
# Regression: sed-escape fix — & and | must appear literally in projekt.md
OKF_TODAY=2026-06-18 bash "$S" "Edge proj" --klient "Johnson & Partners | EU" --root "$tmp"
grep -qF 'klient: Johnson & Partners | EU' "$tmp/edge-proj/projekt.md" || { echo "sed-escape failed"; exit 1; }
# no-touch: refuse existing
if OKF_TODAY=2026-06-18 bash "$S" "HITL kampaň Q3" --root "$tmp" 2>/dev/null; then echo "should refuse existing"; exit 1; fi
# conformance
bash "$HERE/../scripts/okf-validate.sh" "$d" >/dev/null || { echo "not OKF conformant"; exit 1; }
echo "new-projekt_test OK"
