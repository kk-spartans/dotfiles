# Omarchy port plan

Migrate the Omarchy look-and-feel and its useful machinery onto this flake, for
`kk-spartans` first, gated so only GUI hosts get it. The live `/etc/nixos`
checkout is untouched while this branch is worked on; merge happens by
reviewing this branch.

## Ground rules

- Everything ships inside this repo. No Omarchy flake input: the needed subset
  of `kk-spartans/omarchy` (quattro) is vendored under
  `modules/programs/gui/hyprland/quickshell/src/`.
- Follow the repo's existing structure idioms: component directory with an
  entry `.nix`, sibling `.nix` files per concern, derivations inline in the
  module that consumes them, home-manager written directly as
  `home-manager.users.kk-spartans = { ... }`, gating through the existing
  `pc` flag chain.
- Keep-rule: nothing already in this flake gets removed unless Omarchy
  overrides that exact function. herdr, spotify/spicetify, discord/nixcord,
  obsidian, zen/helium, activitywatch, kanata, ie-r, minecraft, fish, chezmoi,
  sops, disko all stay as-is.
- No Arch machinery: no pacman/AUR/channels/migrations/ISO/pacman-guard code.
  No hardware quirks from Omarchy; hardware stays handled by this repo's
  modules (gpu.nix etc.).
- Every vendored command must work on NixOS. Nothing cosmetic or
  Arch-dependent ships: no omarchy-version, channels, pkg group, update group,
  webapps, Windows VM, Steam/gaming, screensaver, voxtype, DNS switcher,
  disk benchmarks, transcode, hibernation wizard.
- No Omarchy config indirection that Nix already does better: OMARCHY_PATH is
  exported with `environment.sessionVariables`; there is no
  `/etc/omarchy.conf`, no env-bootstrap chain, no dev-link/channel machinery.
- Where a home-manager module exists it wins over raw files. Kitty stays
  HM-managed and consumes theme colors through a state-file include.

## What replaces what

| Concern | Today | Becomes |
| --- | --- | --- |
| Bar, notifications daemon, lock screen, polkit agent | waybar, swaync, hyprlock, polkit-gnome agent | Omarchy Quickshell shell |
| Idle management | hypridle (laptop-only) | Shell idle service, extended to express this repo's listeners |
| Desktop theming (Hyprland/bar/GTK colors) | catppuccin-nix | Omarchy theme engine, default theme catppuccin |
| CLI theming (fish, fzf, delta, lazy, cava, ...) | catppuccin-nix | Unchanged |
| Wallpapers | bun `wall` tool | Omarchy background system + album-sync feature; wall retired |
| Launcher | vicinae | Kept; SUPER+SPACE goes to Omarchy menu, vicinae chord remapped if it collides |
| Terminal for omarchy commands | xdg-terminal-exec default foot | kitty |

### Idle pipeline (preserves current timings)

Current hypridle listeners are ported into an extension of the vendored shell
idle service (`Service.qml`) which gains generic configurable stages
`{ timeout, action, resume }` next to its native ones. All stages honor the
stay-awake toggle.

| t | action | resume |
| --- | --- | --- |
| 30s | brightness 0 if on battery (marker file) | brightnessctl -r if marker |
| 32s | tpacpi kbd backlight off | restore |
| 60s | DPMS off | DPMS on |
| 1800s | systemctl hibernate | - |

Lock-on-idle stays off (manual locking via the QML lock screen), matching
today's behavior. hypridle module is disabled where the omarchy layer is
active.

## App library on NixOS

Verified compatible: enumeration goes through Quickshell `DesktopEntries`,
which follows XDG_DATA_DIRS (NixOS aggregates profiles correctly); launches go
through `uwsm-app -- gtk-launch`; icon fallback scans `$XDG_DATA_DIRS/icons`
plus pixmaps. Requires shipping `omarchy-remove-launcher-entry` and keeping
`applications/icons/`.

## Vendored command set

Curated union of:

- everything referenced by the shell QML/plugins,
- every action in the pruned menu JSONC,
- core Hyprland bindings (tiling/utilities/clipboard/media),
- the theme engine call chain,
- capture suite including OCR,
- reminders and weather,
- album-sync (new).

Excluded even though portable: branding screensaver, about animation, webapp
wrappers, gaming installers, hw-* detectors, debug ISO binaries.

## Repo layout

```
modules/programs/gui/hyprland/quickshell/
├── shell.nix        entry: imports siblings; NixOS-level integration
├── src/               vendored trimmed omarchy tree
├── runtime.nix        inline derivations: share tree, tool closure, wrapped bin/*
├── idle.nix           extended idle Service.qml + the four listeners above
├── theme.nix          theme engine wiring, first-login catppuccin, kitty include
├── units.nix          bt-agent, sleep-lock, recover-monitor, crash-watch
└── album-sync.nix     MPRIS → palette → nearest theme + tinted background

hosts/omarchy-dev/     minimal VM profile (virtio GPU, pc=true)
```

`gui.nix` imports the directory when `pc` is true; later hosts flip one
boolean.

### Vendored source subset

From the omarchy fork: `bin/` curated set, `shell/` core (minus dev-gallery
and unused plugins), `themes/catppuccin/`,
`default/hypr/` (minus nvidia.lua and provisioning autostart lines),
`default/themed/` state targets only, `default/fonts/omarchy/omarchy.ttf`
(bar glyphs depend on it), pruned `omarchy-menu.jsonc`,
`applications/icons/`, logo/icon branding assets.

Menu JSONC is copied with update/migration/install/channel/system-update
entries removed.

## Phases

1. Vendor & curate: copy the subset above; strip arch commands; grep-audit
   every kept script for pacman/limine/snapper references; prune menu JSONC.
2. Runtime packaging: assemble `$out/share/omarchy`, build a ~80-tool closure
   symlink dir, wrap each bin script with PATH and OMARCHY_PATH, patch any
   hardcoded paths found in the audit.
3. NixOS integration: systemPackages, session variables, noto fonts +
   omarchy.ttf, gtk portal alongside the hyprland portal, polkit,
   power-profiles-daemon, xdg-terminal-exec pointing at kitty.
4. Home-manager concerns: disable waybar/swaync/hyprlock/hypridle/polkit-gnome
   unit/wallpaper module scoped to omarchy hosts; Hyprland Lua merge
   (`require("default.hypr.omarchy")` with preinstalled bindings off, personal
   binds after, catppuccin.hyprland off); copy-if-absent seed of
   `~/.config/omarchy/**` only; idle port; user units.
5. Album sync: playerctl metadata → imagemagick kmeans palette → score against
   every theme's colors.toml → theme-set plus palette-tinted background;
   bar button; optional auto-follow toggle on track change.
6. Verify & ship: treefmt, `nix flake check`, `nixos-rebuild build-vm --flake
   .#omarchy-dev`, then atomic commits.

## Verification checklist

- Bar renders with omarchy.ttf glyphs; menu opens with pruned entries.
- Theme hot-switch updates Hyprland, bar, GTK, kitty include.
- Manual lock shows QML lock screen; PAM auth works.
- Idle ladder fires at 30/32/60/1800s (observable in VM logs); stay-awake
  toggle suspends all of it.
- Capture screenshot/region/OCR work; reminders fire; weather widget loads.
- Album-sync button switches theme and tinted background.
- raspi host still evaluates without the gui stack; mac-pro unaffected.

## Risks

- Quickshell API skew: nixpkgs quickshell (0.3.0) may lag the shell's QML
  expectations; fallback is a quickshell flake input, one line away.
- Hyprland git-flake Lua drift versus the vendored helper API; caught at VM
  boot, shimmed in the merge point if needed.
- Idle Service.qml extension must stay small enough to stay diffable against
  upstream for future pulls.
- Template leakage: theme rendering narrowed to state-file targets only;
  audit before first run.
