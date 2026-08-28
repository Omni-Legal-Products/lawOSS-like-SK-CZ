#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; SC="$HERE/../scripts"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export OKF_TODAY=2026-06-18

# legacy spis folder: a pre-existing (already-conformant) AGENTS.md + a document + a subfolder
legacy="$tmp/2024-03 Stará Vec - spor"
mkdir -p "$legacy/1 - Podklady"
printf -- '---\ntype: agents\ntitle: Stará Vec — AGENTS\nupdated: 2024-03-01\n---\nCUSTOM AGENTS — do not overwrite\n' > "$legacy/AGENTS.md"
printf 'zaloba PDF placeholder\n' > "$legacy/1 - Podklady/zaloba.pdf"
agents_sum_before="$(cksum "$legacy/AGENTS.md")"
doc_sum_before="$(cksum "$legacy/1 - Podklady/zaloba.pdf")"

bash "$SC/retrofit.sh" spis "$legacy" --protistrana "Kameňolomy a štrkopieskovne, a.s."

# missing files added
for f in spis.md _STATUS.md MEMORY.md; do [ -f "$legacy/$f" ] || { echo "missing $f"; exit 1; }; done
grep -q '^type: spis' "$legacy/spis.md" || { echo "spis.md type"; exit 1; }
grep -qF 'Kameňolomy a štrkopieskovne, a.s.' "$legacy/spis.md" || { echo "protistrana not filled/escaped"; exit 1; }
# pre-existing AGENTS.md NOT overwritten
[ "$(cksum "$legacy/AGENTS.md")" = "$agents_sum_before" ] || { echo "AGENTS.md OVERWRITTEN"; exit 1; }
# document + subfolder untouched
[ "$(cksum "$legacy/1 - Podklady/zaloba.pdf")" = "$doc_sum_before" ] || { echo "document TOUCHED"; exit 1; }
[ -d "$legacy/1 - Podklady" ] || { echo "subfolder lost"; exit 1; }
# CLAUDE.md created as copy of the pre-existing AGENTS.md (Profile A copy-mirror)
[ -f "$legacy/CLAUDE.md" ] && [ ! -L "$legacy/CLAUDE.md" ] || { echo "CLAUDE.md not a copy"; exit 1; }
cmp -s "$legacy/AGENTS.md" "$legacy/CLAUDE.md" || { echo "CLAUDE.md != AGENTS.md"; exit 1; }
# conformant under the STRICT validator
bash "$SC/okf-validate.sh" "$legacy" >/dev/null || { echo "not OKF conformant"; exit 1; }

# idempotent: second run mutates nothing
spis_sum="$(cksum "$legacy/spis.md")"
bash "$SC/retrofit.sh" spis "$legacy"
[ "$(cksum "$legacy/spis.md")" = "$spis_sum" ] || { echo "second run mutated spis.md"; exit 1; }
[ "$(cksum "$legacy/AGENTS.md")" = "$agents_sum_before" ] || { echo "second run touched AGENTS.md"; exit 1; }

# projekt retrofit on empty dir → projekt.md + CLAUDE symlink, conformant
proj="$tmp/web-vec"; mkdir -p "$proj"
bash "$SC/retrofit.sh" projekt "$proj"
[ -f "$proj/projekt.md" ] && [ -L "$proj/CLAUDE.md" ] || { echo "projekt retrofit wrong"; exit 1; }
bash "$SC/okf-validate.sh" "$proj" >/dev/null || { echo "projekt not conformant"; exit 1; }

# klient retrofit with --ico must fill the IČO in klient.md
kdir="$tmp/Acme s.r.o."; mkdir -p "$kdir"
bash "$SC/retrofit.sh" klient "$kdir" --ico 35868960
grep -q 'ico: "35868960"' "$kdir/klient.md" || { echo "klient --ico not filled"; exit 1; }
bash "$SC/okf-validate.sh" "$kdir" >/dev/null || { echo "klient not conformant"; exit 1; }

# --- upgrade mode: inject frontmatter into existing frontmatter-less control files ---
up="$tmp/2024-09 Upgrade Vec"
mkdir -p "$up/1 - Podklady"
printf 'CUSTOM AGENTS v1.0 body\n'  > "$up/AGENTS.md"     # no frontmatter (v1.0 style)
printf 'CUSTOM STATUS v1.0 body\n'  > "$up/_STATUS.md"    # no frontmatter
printf 'doc\n'                      > "$up/1 - Podklady/x.pdf"
pdf_b="$(cksum "$up/1 - Podklady/x.pdf")"
bash "$SC/retrofit.sh" spis "$up" --upgrade
# AGENTS upgraded: frontmatter added AND original body preserved
[ "$(head -n1 "$up/AGENTS.md")" = "---" ] || { echo "AGENTS not upgraded"; exit 1; }
grep -q '^type: agents' "$up/AGENTS.md" || { echo "AGENTS type missing"; exit 1; }
grep -qF 'CUSTOM AGENTS v1.0 body' "$up/AGENTS.md" || { echo "AGENTS body lost"; exit 1; }
# _STATUS upgraded
grep -q '^type: status' "$up/_STATUS.md" || { echo "STATUS type missing"; exit 1; }
grep -qF 'CUSTOM STATUS v1.0 body' "$up/_STATUS.md" || { echo "STATUS body lost"; exit 1; }
# missing card created
grep -q '^type: spis' "$up/spis.md" || { echo "spis.md not created"; exit 1; }
# document untouched
[ "$(cksum "$up/1 - Podklady/x.pdf")" = "$pdf_b" ] || { echo "doc touched"; exit 1; }
# strict conformance
bash "$SC/okf-validate.sh" "$up" >/dev/null || { echo "upgrade not conformant"; exit 1; }
# idempotent: second --upgrade changes nothing
a_sum="$(cksum "$up/AGENTS.md")"
bash "$SC/retrofit.sh" spis "$up" --upgrade
[ "$(cksum "$up/AGENTS.md")" = "$a_sum" ] || { echo "second upgrade mutated AGENTS"; exit 1; }

# --- default mode does NOT upgrade existing frontmatter-less control files ---
nd="$tmp/2024-10 NoUpgrade"; mkdir -p "$nd"
printf 'plain agents\n' > "$nd/AGENTS.md"
bash "$SC/retrofit.sh" spis "$nd"            # NO --upgrade
[ "$(head -n1 "$nd/AGENTS.md")" != "---" ] || { echo "default mode wrongly upgraded AGENTS"; exit 1; }

# --- safety: --upgrade NEVER injects into a non-control .md (a document) ---
sd="$tmp/safety-proj"; mkdir -p "$sd"
printf 'just a note, no frontmatter\n' > "$sd/poznamky.md"
note_b="$(cksum "$sd/poznamky.md")"
bash "$SC/retrofit.sh" projekt "$sd" --upgrade
[ "$(cksum "$sd/poznamky.md")" = "$note_b" ] || { echo "SAFETY: non-control .md was modified"; exit 1; }

# upgrade title must be CLEAN for dir names containing & (no stray backslash)
amp="$tmp/Čuprík & Partneri"; mkdir -p "$amp"
printf 'v1 body\n' > "$amp/AGENTS.md"
bash "$SC/retrofit.sh" klient "$amp" --upgrade
grep -qF 'title: Čuprík & Partneri' "$amp/AGENTS.md" || { echo "title escaping wrong: $(grep '^title:' "$amp/AGENTS.md")"; exit 1; }
grep -q '\\&' "$amp/AGENTS.md" && { echo "stray backslash in upgraded file"; exit 1; }
grep -qF 'v1 body' "$amp/AGENTS.md" || { echo "body lost"; exit 1; }

# --- --protocol: append write-back protokol to existing AGENTS/CLAUDE ---
pr="$tmp/2023-05 Protokol Vec"
mkdir -p "$pr"
printf -- '---\ntype: agents\ntitle: X\n---\nSTARÝ obsah AGENTS\n' > "$pr/AGENTS.md"
printf -- '---\ntype: agents\ntitle: X\n---\nSTARÝ obsah CLAUDE (divergentný)\n' > "$pr/CLAUDE.md"
bash "$SC/retrofit.sh" spis "$pr" --protocol
grep -qF '<!-- okf:protokol-zapisu:v1 -->' "$pr/AGENTS.md" || { echo "protokol not appended to AGENTS"; exit 1; }
grep -qF '<!-- okf:protokol-zapisu:v1 -->' "$pr/CLAUDE.md" || { echo "protokol not appended to CLAUDE"; exit 1; }
grep -qF 'STARÝ obsah AGENTS' "$pr/AGENTS.md" || { echo "AGENTS body lost"; exit 1; }
grep -qF 'STARÝ obsah CLAUDE (divergentný)' "$pr/CLAUDE.md" || { echo "CLAUDE divergent body lost"; exit 1; }
# idempotent: second run adds nothing
a_sum2="$(cksum "$pr/AGENTS.md")"
bash "$SC/retrofit.sh" spis "$pr" --protocol
[ "$(cksum "$pr/AGENTS.md")" = "$a_sum2" ] || { echo "second --protocol run mutated AGENTS"; exit 1; }
# marker count must be exactly 1 (no double-append)
[ "$(grep -cF 'okf:protokol-zapisu:v1' "$pr/AGENTS.md")" = "1" ] || { echo "marker duplicated"; exit 1; }
# symlink CLAUDE (projekt) is skipped, no double content via link
plink="$tmp/proto-proj"; mkdir -p "$plink"
printf -- '---\ntype: agents\ntitle: P\n---\nprojekt agents\n' > "$plink/AGENTS.md"
( cd "$plink" && ln -s AGENTS.md CLAUDE.md )
bash "$SC/retrofit.sh" projekt "$plink" --protocol
[ "$(grep -cF 'okf:protokol-zapisu:v1' "$plink/AGENTS.md")" = "1" ] || { echo "symlink case double-append"; exit 1; }
# composes with --upgrade on a frontmatter-less v1.0 file
comp="$tmp/2022-01 Compose"
mkdir -p "$comp"; printf 'v1 telo bez frontmatteru\n' > "$comp/AGENTS.md"
bash "$SC/retrofit.sh" spis "$comp" --upgrade --protocol
[ "$(head -n1 "$comp/AGENTS.md")" = "---" ] || { echo "compose: no frontmatter"; exit 1; }
grep -qF 'v1 telo bez frontmatteru' "$comp/AGENTS.md" || { echo "compose: body lost"; exit 1; }
grep -qF 'okf:protokol-zapisu:v1' "$comp/AGENTS.md" || { echo "compose: no protokol"; exit 1; }

echo "retrofit_test OK"
