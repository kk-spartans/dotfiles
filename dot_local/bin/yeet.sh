#!/usr/bin/env bash
set -euo pipefail

for path in "$@"; do
  rm -rf -- "$path" 2>/dev/null || true
done
