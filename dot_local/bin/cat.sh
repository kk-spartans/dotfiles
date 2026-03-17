#!/usr/bin/env bash
set -euo pipefail

# Mirror PowerShell version behavior:
# - Expand ~
# - Support glob patterns
# - If a directory is passed, show all regular files in it (no recursion)

show_file() {
  local target="$1"

  if [[ "$target" == "-" ]]; then
    bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" -
    return
  fi

  if [[ "$target" =~ \.(md|markdown)$ ]]; then
    glow "$target"
  else
    bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" "$target"
  fi
}

for input in "$@"; do
  # Expand ~ to $HOME
  path="${input/#\~/$HOME}"

  matches=()
  if [[ "$path" == *[\*\?\[]* ]]; then
    # Glob pattern
    shopt -s nullglob
    # shellcheck disable=SC2206
    matches=($path)
    shopt -u nullglob
  else
    matches=("$path")
  fi

  for target in "${matches[@]}"; do
    if [[ -d "$target" ]]; then
      while IFS= read -r -d $'\0' file; do
        show_file "$file"
      done < <(find "$target" -maxdepth 1 -type f -print0 2>/dev/null)
      continue
    fi

    if [[ -e "$target" ]]; then
      show_file "$target"
    fi
  done
done
