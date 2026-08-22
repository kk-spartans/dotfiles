#!/usr/bin/env bash
set -Eeuo pipefail

log() {
  printf '[cleanup] %s\n' "$*"
}

on_error() {
  printf '[cleanup] failed near line %s\n' "$1" >&2
}
trap 'on_error "$LINENO"' ERR

STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
USER_PROFILE="$STATE_HOME/nix/profiles/profile"
HM_STATE="$STATE_HOME/home-manager"
CACHE_DIR="$HOME/.cache"

TOTAL_BYTES=0

human_size() {
  awk -v b="$1" 'BEGIN {
    split("B KiB MiB GiB TiB PiB", u, " ")
    i = 1
    while (b >= 1024 && i < 6) { b /= 1024; i++ }
    printf "%.2f %s", b, u[i]
  }'
}

float_to_bytes() {
  awk -v v="$1" -v m="$2" 'BEGIN { printf "%.0f", v * m }'
}

record_recovered() {
  local label=$1 bytes=$2
  TOTAL_BYTES=$(( TOTAL_BYTES + bytes ))
  log "${label}: recovered $(human_size "$bytes")"
}

dir_size_bytes() {
  local p=$1 prefix=() out val unit mult
  if [[ ${2:-} == sudo ]]; then
    prefix=(sudo)
  fi
  if [[ ! -e $p && ! -L $p ]]; then
    printf '0\n'
    return
  fi
  if command -v diskus >/dev/null 2>&1; then
    out="$("${prefix[@]}" diskus --size-format binary -- "$p" 2>/dev/null)" || out=''
    [[ -n $out ]] || { printf '0\n'; return; }
    val="${out%% *}"
    unit="${out##* }"
    if [[ $val == "$unit" ]]; then
      printf '%s\n' "$val"
      return
    fi
    case $unit in
      KiB) mult=1024 ;;
      MiB) mult=1048576 ;;
      GiB) mult=1073741824 ;;
      TiB) mult=$((1073741824 * 1024)) ;;
      PiB) mult=$((1073741824 * 1024 * 1024)) ;;
      *)   mult=1 ;;
    esac
    float_to_bytes "$val" "$mult"
  else
    out="$("${prefix[@]}" du -sb -- "$p" 2>/dev/null | awk '{print $1}')" || out=''
    printf '%s\n' "${out:-0}"
  fi
}

parse_freed_bytes() {
  # Reads tool output on stdin, prints the last "<n> <unit> freed"-style size as bytes.
  local line val unit mult
  line="$(grep -Eo '[0-9]+(\.[0-9]+)? [A-Za-z]+ freed' | tail -n 1 || true)"
  [[ -n $line ]] || { printf '0\n'; return; }
  val="${line%% *}"
  unit="${line#* }"; unit="${unit%% *}"
  case $unit in
    B)   mult=1 ;;
    KiB) mult=1024 ;;
    MiB) mult=1048576 ;;
    GiB) mult=1073741824 ;;
    TiB) mult=$((1073741824 * 1024)) ;;
    PiB) mult=$((1073741824 * 1024 * 1024)) ;;
    kB)  mult=1000 ;;
    MB)  mult=1000000 ;;
    GB)  mult=1000000000 ;;
    TB)  mult=1000000000000 ;;
    *)   mult=1 ;;
  esac
  float_to_bytes "$val" "$mult"
}

log "Removing old NixOS system generations"
if [[ -e /nix/var/nix/profiles/system || -L /nix/var/nix/profiles/system ]]; then
  sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
else
  log "NixOS system profile not found; skipping"
fi

log "Removing all non-current generations from the user Nix profile"
if [[ -e "$USER_PROFILE" || -L "$USER_PROFILE" ]]; then
  nix profile wipe-history --profile "$USER_PROFILE"
else
  log "User Nix profile not found; skipping"
fi

if [[ -e "$HOME/.nix-profile" || -L "$HOME/.nix-profile" ]]; then
  log "Removing old generations from the legacy user profile"
  nix-env --profile "$HOME/.nix-profile" --delete-generations old || true
fi

log "Removing old Home Manager generations"
if command -v home-manager >/dev/null 2>&1; then
  home-manager expire-generations '-1 days'
else
  log "home-manager is not on PATH; removing non-current standalone HM roots if present"
  if [[ -d "$HM_STATE/gcroots" ]]; then
    find "$HM_STATE/gcroots" -mindepth 1 -maxdepth 1 -type l \
      ! -name current-home -delete
  fi
  for hm_profile in "$STATE_HOME/nix/profiles/home-manager" "$HM_STATE/profile"; do
    if [[ -e "$hm_profile" || -L "$hm_profile" ]]; then
      nix profile wipe-history --profile "$hm_profile"
    fi
  done
fi

log "Collecting unreachable Nix store paths"
gc_output="$(sudo nix-collect-garbage 2>&1)" || true
record_recovered "Nix garbage collection" "$(parse_freed_bytes <<<"$gc_output")"

log "Pruning unused Docker resources"
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker_output="$(docker system prune --all --force --volumes 2>&1)" || true
  reclaim_line="$(grep '^Total reclaimed space:' <<<"$docker_output" | tail -n 1 || true)"
  if [[ -n $reclaim_line ]]; then
    payload="${reclaim_line#*: }"
    val="${payload%%[!0-9.]*}"
    unit="${payload#"$val"}"
    case $unit in
      B)  docker_mult=1 ;;
      kB) docker_mult=1000 ;;
      MB) docker_mult=1000000 ;;
      GB) docker_mult=1000000000 ;;
      TB) docker_mult=1000000000000 ;;
      *)  docker_mult=1 ;;
    esac
    record_recovered "Docker prune" "$(float_to_bytes "${val:-0}" "$docker_mult")"
  else
    record_recovered "Docker prune" 0
  fi
else
  log "Docker daemon is unavailable; skipping Docker prune"
fi

log "Removing everything inside /tmp while preserving /tmp itself"
if [[ -d /tmp ]]; then
  tmp_bytes="$(dir_size_bytes /tmp sudo)"
  sudo find /tmp -mindepth 1 ! -path /tmp/opencode\* -exec rm -rf -- {} +
  record_recovered "/tmp" "$tmp_bytes"
else
  log "/tmp does not exist; skipping"
fi

log "Removing everything inside $CACHE_DIR while preserving the directory"
if [[ -d "$CACHE_DIR" ]]; then
  cache_bytes="$(dir_size_bytes "$CACHE_DIR")"
  find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
  record_recovered "\$HOME/.cache" "$cache_bytes"
else
  log "$CACHE_DIR does not exist; skipping"
fi

log "Removing misc caches and trash directories"
for path in \
  "$HOME/.local/share/Trash" \
  "$HOME/.local/share/pnpm" \
  "$HOME/.bun/install/cache" \
  "$HOME/.npm/_cacache" \
  "$HOME/.npm/_npx" \
  "$HOME/.codex/.tmp" \
  "$HOME/.codex/cache" \
  "$HOME/.agent-browser/tmp" \
  "$HOME/.docker/buildx"; do
  if [[ -e "$path" || -L "$path" ]]; then
    path_bytes="$(dir_size_bytes "$path")"
    rm -rf -- "$path"
    record_recovered "${path/#"$HOME"/'~'}" "$path_bytes"
  fi
done

sync
log "Total space recovered: $(human_size "$TOTAL_BYTES")"
log "Cleanup complete"
