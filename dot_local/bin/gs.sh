#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: gs <commit message>" >&2
  exit 1
fi

git add --all
git commit -S -m "$1"
git pull --rebase
git push
git status
