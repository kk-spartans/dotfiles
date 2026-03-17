#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "cp needs at least a source and a destination" >&2
  exit 1
fi

cp -r "$@"
