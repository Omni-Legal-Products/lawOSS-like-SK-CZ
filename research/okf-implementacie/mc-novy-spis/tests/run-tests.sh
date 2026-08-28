#!/usr/bin/env bash
# Runs every *_test.sh in this dir. Exit non-zero if any fails.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pass=0; fail=0
for t in "$HERE"/*_test.sh; do
  [ -e "$t" ] || continue
  echo "── $(basename "$t")"
  if bash "$t"; then pass=$((pass+1)); else fail=$((fail+1)); echo "   FAILED: $(basename "$t")"; fi
done
echo "── result: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
