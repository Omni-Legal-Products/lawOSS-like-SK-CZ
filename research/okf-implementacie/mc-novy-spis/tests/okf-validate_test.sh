#!/usr/bin/env bash
set -eu
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V="$HERE/../scripts/okf-validate.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# conformant bundle
printf -- '---\ntype: spis\n---\n# ok\n' > "$tmp/spis.md"
printf -- '- [a](a.md)\n'               > "$tmp/index.md"   # listing, no frontmatter
bash "$V" "$tmp" || { echo "should pass clean bundle"; exit 1; }

# violation: concept without type
printf -- '---\ntitle: no type\n---\n' > "$tmp/bad.md"
if bash "$V" "$tmp"; then echo "should fail missing type"; exit 1; fi
rm "$tmp/bad.md"

# root index.md with only okf_version — must pass
printf -- '---\nokf_version: "0.1"\n---\n' > "$tmp/index.md"
bash "$V" "$tmp" || { echo "should pass root index with only okf_version"; exit 1; }
printf -- '- [a](a.md)\n' > "$tmp/index.md"   # restore listing form

# violation: index.md with frontmatter
printf -- '---\ntype: register\n---\n' > "$tmp/index.md"
if bash "$V" "$tmp"; then echo "should fail index frontmatter"; exit 1; fi

echo "okf-validate_test OK"
