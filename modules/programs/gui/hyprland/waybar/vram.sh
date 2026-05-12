#!/usr/bin/env bash

# If nvidia-smi doesn't exist or driver is dead → just print 0.0GB
if ! command -v nvidia-smi >/dev/null 2>&1; then
    printf "0.0GB\n"
    exit 0
fi

# Grab first valid value only
mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | head -n1)

# If it's empty or not a number → fallback
if [[ -z "$mem_used" || ! "$mem_used" =~ ^[0-9]+$ ]]; then
    printf "0.0GB\n"
    exit 0
fi

# Convert MB → GB
awk -v m="$mem_used" 'BEGIN { printf "%.1f\n", m/1024 }'
