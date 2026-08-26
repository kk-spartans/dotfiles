#!/bin/bash

# Album-art adaptive theming for Omarchy.
#
# Reads the MPRIS currently-playing track, extracts the cover art's dominant
# palette, switches to the installed theme whose colors best match it, and
# re-tints the current background toward the album colors.
#
# Usage: omarchy-album-sync [once|follow]

set -euo pipefail

MODE="${1:-once}"

THEMES_DIR="$OMARCHY_PATH/themes"
STATE_DIR="$HOME/.local/state/omarchy/current"
CACHE_DIR="$HOME/.cache/omarchy/album-sync"
mkdir -p "$CACHE_DIR"

art_url() {
  playerctl metadata mpris:artUrl 2>/dev/null || true
}

dominant_colors() {
  local image="$1" count="${2:-5}"
  magick "$image" -resize 200x200^ -gravity center -extent 200x200 \
    +dither -colors "$count" -unique-colors txt:- |
    awk 'NR>1 { gsub("#",""); print "#" substr($2, 1, 6) }'
}

color_distance() {
  awk -v a="$1" -v b="$2" '
    BEGIN {
      d = 0
      for (i = 0; i < 3; i++) {
        ca = strtonum("0x" substr(a, 1 + i * 2, 2))
        cb = strtonum("0x" substr(b, 1 + i * 2, 2))
        d += (ca - cb) ^ 2
      }
      printf "%d", d
    }'
}

score_theme() {
  local colors_file="$1" value dist best total=0
  [[ -f $colors_file ]] || return 1
  while IFS=$'\t' read -r _ value; do
    [[ $value =~ ^#[0-9a-fA-F]{6}$ ]] || continue
    best=999999999
    for album in "${ALBUM_COLORS[@]}"; do
      dist=$(color_distance "${value#\#}" "${album#\#}")
      (( dist < best )) && best=$dist
    done
    total=$(( total + best ))
  done < <(awk -F' = ' '/^(accent|background) *=/ { gsub(/"/,"",$2); print $1 "\t" $2 }' "$colors_file")
  echo "$total"
}

pick_theme() {
  local best_name="" best_score=999999999 score name dir
  for dir in "$THEMES_DIR"/*; do
    [[ -d $dir ]] || continue
    name=$(basename "$dir")
    score=$(score_theme "$dir/colors.toml") || continue
    [[ -z $score ]] && continue
    if (( score < best_score )); then
      best_score=$score
      best_name=$name
    fi
  done
  [[ -n $best_name ]] && echo "$best_name"
}

tinted_background() {
  local src="$1" out="$2" accent
  accent="${ALBUM_COLORS[0]#\#}"
  magick "$src" \( -clone 0 -fill "#$accent" -colorize 18% \) \
    -delete 0 -compose multiply -composite "$out"
}

apply_current_background_tint() {
  local current bg out
  current=$(readlink "$STATE_DIR/background" 2>/dev/null) || return 0
  [[ -e $current ]] || return 0
  case "$current" in
    "$CACHE_DIR"/*) return 0 ;;  # already a tinted copy
  esac
  bg=$(basename "$current")
  out="$CACHE_DIR/$bg"
  tinted_background "$current" "$out" || return 0
  omarchy-theme-bg-set "$out"
}

run_once() {
  local url image theme
  url=$(art_url)
  [[ -n $url ]] || { echo "No playing track with cover art" >&2; exit 1; }
  case "$url" in
    file://*) image=${url#file://} ;;
    *) image="$CACHE_DIR/cover.img"; curl -fsSL "$url" -o "$image" ;;
  esac

  mapfile -t ALBUM_COLORS < <(dominant_colors "$image")
  (( ${#ALBUM_COLORS[@]} )) || { echo "Could not extract palette" >&2; exit 1; }

  theme=$(pick_theme)
  if [[ -n $theme ]]; then
    omarchy-theme-set "$theme"
    apply_current_background_tint || true
  else
    echo "No themes found in $THEMES_DIR" >&2
    exit 1
  fi
}

case "$MODE" in
  once) run_once ;;
  follow)
    # Re-run whenever the playing track changes.
    playerctl -F metadata --format '{{mpris:artUrl}}' 2>/dev/null |
      while read -r _; do
        run_once >/dev/null 2>&1 || true
        sleep 2
      done
    ;;
  *)
    echo "Usage: omarchy-album-sync [once|follow]" >&2
    exit 1
    ;;
esac
