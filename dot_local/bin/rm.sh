#!/usr/bin/env bash
set -euo pipefail

for path in "$@"; do
  trash "$path" --verbose 2>/dev/null || true
done
