#!/usr/bin/env bash
# Verify required CLI tools exist.
set -u
missing=0
for bin in bash awk sed grep date; do
  command -v "$bin" >/dev/null 2>&1 || { echo "missing: $bin"; missing=1; }
done
exit "$missing"
