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
sudo nix-collect-garbage

log "Pruning unused Docker resources"
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker system prune --all --force --volumes
else
  log "Docker daemon is unavailable; skipping Docker prune"
fi

log "Removing everything inside /tmp while preserving /tmp itself"
if [[ -d /tmp ]]; then
  sudo find /tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
else
  log "/tmp does not exist; skipping"
fi

log "Removing everything inside $CACHE_DIR while preserving the directory"
if [[ -d "$CACHE_DIR" ]]; then
  find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
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
  rm -rf -- "$path"
done

sync
log "Cleanup complete"
