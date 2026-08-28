#!/usr/bin/env bash
# Shared helpers for novy-spis scripts. Source me: . "$(dirname "$0")/lib.sh"

okf_die() { echo "novy-spis: $*" >&2; exit 1; }

okf_today() { echo "${OKF_TODAY:-$(date +%F)}"; }

# Extract a top-level scalar frontmatter value (between the first two '---').
okf_fm_get() {
  local file="$1" key="$2"
  awk -v k="$key" '
    NR==1 && $0=="---" { infm=1; next }
    infm && $0=="---" { exit }
    infm {
      # match: key: value   (value may be quoted)
      if ($0 ~ "^"k"[[:space:]]*:") {
        sub("^"k"[[:space:]]*:[[:space:]]*", "")
        gsub(/^"|"$/, "")
        print
        exit
      }
    }
  ' "$file"
}

# ascii slug: lowercase, strip diacritics, non-alnum -> single dash
okf_slug() {
  printf '%s' "$1" \
    | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null \
    | tr -d "'" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

# Escape a string for safe use as a sed replacement (handles \, |, &).
okf_sed_escape() { printf '%s' "$1" | sed -e 's/[\\]/\\\\/g' -e 's/[|&]/\\&/g'; }
