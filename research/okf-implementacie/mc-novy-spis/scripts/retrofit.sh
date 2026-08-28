#!/usr/bin/env bash
# retrofit.sh — non-destructive OKF retrofit of an existing folder.
# Usage: retrofit.sh <typ> <dir> [--title "X"] [--ico X] [--klient X]
#        [--klient-ico X] [--protistrana X] [--protistrana-ico X] [--oblast X]
# Only CREATE files that are absent. NEVER overwrite, delete, or modify any
# pre-existing file, document, or subfolder.
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"

# ── parse positional typ + dir, then flags ───────────────────────────────────
[ $# -ge 2 ] || okf_die "usage: retrofit.sh <typ> <dir> [flags]"
typ="$1"; dir="$2"; shift 2

title=""; ico=""; klient=""; klient_ico=""; protistrana=""; pico=""; oblast=""; upgrade=0; protocol=0
while [ $# -gt 0 ]; do case "$1" in
  --title)           title="$2";      shift 2;;
  --ico)             ico="$2";        shift 2;;
  --klient)          klient="$2";     shift 2;;
  --klient-ico)      klient_ico="$2"; shift 2;;
  --protistrana)     protistrana="$2";shift 2;;
  --protistrana-ico) pico="$2";       shift 2;;
  --oblast)          oblast="$2";     shift 2;;
  --upgrade)         upgrade=1;       shift;;
  --protocol)        protocol=1;      shift;;
  *) okf_die "unknown flag: $1";;
esac; done

# ── normalize flags by typ ───────────────────────────────────────────────────
# klient's --ico fills the klient IČO field
[ "$typ" = "klient" ] && [ -n "$ico" ] && [ -z "$klient_ico" ] && klient_ico="$ico"

# ── validate ─────────────────────────────────────────────────────────────────
case "$typ" in klient|spis|projekt) ;; *) okf_die "typ must be klient, spis, or projekt; got: $typ";; esac
[ -d "$dir" ] || okf_die "not an existing directory: $dir"

# ── defaults ─────────────────────────────────────────────────────────────────
[ -n "$title" ] || title="$(basename "$dir")"
today="$(okf_today)"
TPL="$HERE/../templates/$typ"
PARTIAL="$HERE/../templates/partials/protokol-zapisu.md"
[ "$protocol" = 1 ] && [ ! -f "$PARTIAL" ] && okf_die "protocol partial missing: $PARTIAL"

# ── fill function (same escaping pattern as new-spis.sh / new-projekt.sh) ────
fill() {
  local t k ki p pi o d
  t="$(okf_sed_escape "$title")"
  k="$(okf_sed_escape "$klient")"
  ki="$(okf_sed_escape "$klient_ico")"
  p="$(okf_sed_escape "$protistrana")"
  pi="$(okf_sed_escape "$pico")"
  o="$(okf_sed_escape "$oblast")"
  d="$(okf_sed_escape "$today")"
  sed -e "s|{{TITLE}}|$t|g" \
      -e "s|{{DESCRIPTION}}||g" \
      -e "s|{{RESOURCE}}||g" \
      -e "s|{{KLIENT}}|$k|g" \
      -e "s|{{KLIENT_ICO}}|$ki|g" \
      -e "s|{{PROTISTRANA}}|$p|g" \
      -e "s|{{PROTISTRANA_ICO}}|$pi|g" \
      -e "s|{{OBLAST}}|$o|g" \
      -e "s|{{SPZN}}||g" \
      -e "s|{{SUD}}||g" \
      -e "s|{{DATE}}|$d|g" \
      "$1"
}

# ── determine files to create per type ───────────────────────────────────────
case "$typ" in
  klient)  files="klient.md AGENTS.md MEMORY.md";;
  spis)    files="spis.md _STATUS.md AGENTS.md MEMORY.md";;
  projekt) files="projekt.md AGENTS.md MEMORY.md";;
esac

# ── create missing files only ────────────────────────────────────────────────
for fname in $files; do
  dest="$dir/$fname"
  if [ -e "$dest" ]; then
    echo "skip (exists): $fname"
  else
    fill "$TPL/$fname" > "$dest"
    echo "added: $fname"
  fi
done

# ── upgrade pass (--upgrade only): inject frontmatter into recognized control files ──
# Maps each recognized control filename to its type: value
upgrade_file() {  # $1=path $2=type
  local f="$1" t="$2"
  [ -f "$f" ] || return 0
  [ "$(head -n1 "$f")" = "---" ] && return 0   # already has frontmatter → leave
  local ftitle tmp_f mode
  ftitle="$(basename "$dir")"
  mode="$(stat -f '%Lp' "$f")"
  tmp_f="$(mktemp)"
  { printf -- '---\ntype: %s\ntitle: %s\nupdated: %s\n---\n\n' "$t" "$ftitle" "$(okf_today)"; cat "$f"; } > "$tmp_f"
  chmod "$mode" "$tmp_f"
  mv "$tmp_f" "$f"
  echo "upgraded: $(basename "$f")"
}

if [ "$upgrade" = 1 ]; then
  case "$typ" in
    klient)  upgrade_files="klient.md AGENTS.md CLAUDE.md MEMORY.md";;
    spis)    upgrade_files="spis.md _STATUS.md AGENTS.md CLAUDE.md MEMORY.md";;
    projekt) upgrade_files="projekt.md AGENTS.md CLAUDE.md MEMORY.md";;
  esac
  for fname in $upgrade_files; do
    case "$fname" in
      spis.md)    upgrade_file "$dir/$fname" spis;;
      klient.md)  upgrade_file "$dir/$fname" klient;;
      projekt.md) upgrade_file "$dir/$fname" projekt;;
      AGENTS.md)  upgrade_file "$dir/$fname" agents;;
      CLAUDE.md)  upgrade_file "$dir/$fname" agents;;
      MEMORY.md)  upgrade_file "$dir/$fname" memory;;
      _STATUS.md) upgrade_file "$dir/$fname" status;;
    esac
  done
fi

# ── CLAUDE.md mirror ─────────────────────────────────────────────────────────
# Only act if CLAUDE.md is absent AND AGENTS.md is present (new or pre-existing)
if [ ! -e "$dir/CLAUDE.md" ] && [ -f "$dir/AGENTS.md" ]; then
  case "$typ" in
    klient|spis)
      cp "$dir/AGENTS.md" "$dir/CLAUDE.md"
      echo "added: CLAUDE.md (copy)"
      ;;
    projekt)
      ln -s AGENTS.md "$dir/CLAUDE.md"
      echo "added: CLAUDE.md (symlink)"
      ;;
  esac
elif [ -e "$dir/CLAUDE.md" ]; then
  echo "skip (exists): CLAUDE.md"
fi

# ── protocol pass (--protocol only): append write-back protokol partial ─────
protocol_append() {  # $1=path
  local f="$1"
  [ -f "$f" ] || return 0
  [ -L "$f" ] && return 0
  grep -qF 'okf:protokol-zapisu:v1' "$f" && { echo "skip (protokol prítomný): $(basename "$f")"; return 0; }
  { printf '\n'; cat "$PARTIAL"; } >> "$f"
  echo "protokol pridaný: $(basename "$f")"
}

if [ "$protocol" = 1 ]; then
  for fname in AGENTS.md CLAUDE.md; do
    protocol_append "$dir/$fname"
  done
fi

# ── best-effort index refresh of parent dir ──────────────────────────────────
bash "$HERE/index-gen.sh" "$(dirname "$dir")" >/dev/null 2>&1 || true

echo "retrofit done: $dir"
