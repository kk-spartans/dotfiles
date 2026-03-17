#!/usr/bin/env bash
set -euo pipefail

cli_args=()
args=("$@")
i=0

if [ "${#args[@]}" -gt 0 ] && [[ "${args[0]}" != -* ]]; then
  cli_args+=("--prompt" "${args[0]}")
  i=1
fi

if [ "${#args[@]}" -gt "$i" ] && [[ "${args[i]}" != -* ]]; then
  cli_args+=("--model" "${args[i]}")
  i=$((i + 1))
fi

for ((j = i; j < ${#args[@]}; j++)); do
  cli_args+=("${args[j]}")
done

opencode "${cli_args[@]}"
