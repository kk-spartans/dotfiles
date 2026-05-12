#!/usr/bin/env bash
if command -v playerctl &>/dev/null && playerctl status &>/dev/null; then
  playerctl metadata --format '{{title}}' | fold -w 35 -s
fi
