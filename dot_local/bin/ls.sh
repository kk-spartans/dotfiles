#!/usr/bin/env bash
set -euo pipefail

path="${1:-.}"
if [[ "$path" == ~* ]]; then
  path="$HOME${path:1}"
fi

eza --all --git --icons --group-directories-first "$path"
