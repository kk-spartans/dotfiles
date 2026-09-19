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

human_size() {
  awk -v b="$1" 'BEGIN {
    split("B KiB MiB GiB TiB PiB", u, " ")
    i = 1
    while (b >= 1024 && i < 6) { b /= 1024; i++ }
    printf "%.2f %s", b, u[i]
  }'
}

# df-based accounting: single root filesystem covers /, /nix, /home.
avail_bytes() {
  df --output=avail -B1 / | tail -n 1 | tr -d ' '
}

log "Disk usage before cleanup:"
df -h / /boot
BEFORE="$(avail_bytes)"

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
sudo nix-collect-garbage || true

log "Optimising Nix store (hardlink deduplication)"
nix store optimise || true
sudo nix store optimise || true

log "Pruning unused Docker resources"
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker system prune --all --force --volumes || true
  docker builder prune --all --force || true
else
  log "Docker daemon is unavailable; skipping Docker prune"
fi

log "Vacuuming systemd journals"
sudo journalctl --vacuum-time=1s || true
journalctl --user --vacuum-time=1s || true

log "Removing systemd coredumps"
if [[ -d /var/lib/systemd/coredump ]]; then
  sudo rm -f -- /var/lib/systemd/coredump/* || true
fi

log "Removing everything inside /tmp and /var/tmp while preserving the directories"
if [[ -d /tmp ]]; then
  sudo find /tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + || true
else
  log "/tmp does not exist; skipping"
fi
if [[ -d /var/tmp ]]; then
  sudo find /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + || true
fi

log "Removing everything inside $CACHE_DIR while preserving the directory"
if [[ -d "$CACHE_DIR" ]]; then
  find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + || true
else
  log "$CACHE_DIR does not exist; skipping"
fi

log "Removing root's cache"
if [[ -d /root/.cache ]]; then
  sudo rm -rf -- /root/.cache/* || true
fi

log "Cleaning package-manager caches"
if command -v npm >/dev/null 2>&1; then
  npm cache clean --force || true
fi
if command -v pnpm >/dev/null 2>&1; then
  pnpm store prune || true
fi
if command -v uv >/dev/null 2>&1; then
  uv cache clean || true
fi
if command -v cargo >/dev/null 2>&1 && [[ -d "$HOME/.cargo/registry/cache" ]]; then
  rm -rf -- "$HOME"/.cargo/registry/cache/* || true
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
  "$HOME/.docker/buildx" \
  "$HOME/.local/share/opencode/log" \
  "$HOME/.local/share/opencode/tool-output" \
  "$HOME/.t3/userdata/logs" \
  "$HOME/.config/obsidian/Cache" \
  "$HOME/.config/obsidian/Code Cache" \
  "$HOME/.config/obsidian/GPUCache" \
  "$HOME/.config/vesktop/sessionData/Cache" \
  "$HOME/.config/vesktop/sessionData/Code Cache" \
  "$HOME/.config/vesktop/sessionData/GPUCache" \
  "$HOME/.config/discord/Cache" \
  "$HOME/.config/discord/Code Cache" \
  "$HOME/.config/discord/GPUCache" \
  "$HOME/.config/Code/CachedExtensionVSIXs" \
  "$HOME/.config/Code/Cache" \
  "$HOME/.config/Code/CachedData" \
  "$HOME/.config/Code/GPUCache" \
  "$HOME/.config/terminal-browser/Cache" \
  "$HOME/.config/terminal-browser/Code Cache" \
  "$HOME/.config/terminal-browser/GPUCache" \
  "$HOME/.config/terminal-browser-f46d9aae/Cache" \
  "$HOME/.config/terminal-browser-f46d9aae/Code Cache" \
  "$HOME/.config/terminal-browser-f46d9aae/GPUCache"; do
  if [[ -e "$path" || -L "$path" ]]; then
    rm -rf -- "$path" || true
    log "removed ${path/#"$HOME"/'~'}"
  fi
done

sync
AFTER="$(avail_bytes)"
RECOVERED=$(( AFTER - BEFORE ))
log "Disk usage after cleanup:"
df -h / /boot
log "Total space recovered: $(human_size "$RECOVERED")"
log "Cleanup complete"
