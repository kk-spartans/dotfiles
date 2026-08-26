# Entry point for the Omarchy layer.
#
# Imported from ../gui.nix, so activation follows the existing pc flag chain:
# every GUI host gets Omarchy as its desktop shell stack. Siblings provide the
# pieces: runtime.nix packages ./src and exports OMARCHY_PATH, theme.nix wires
# first-login theming, units.nix ports the shipped user services, album-sync
# adds MPRIS-driven theme switching.

{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./runtime.nix
    ./theme.nix
    ./units.nix
    ./album-sync.nix
  ];

  # The shell's polkit plugin replaces polkit-gnome.
  security.polkit.enable = true;

  # GTK file chooser / camera portals alongside xdg-desktop-portal-hyprland.
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  home-manager.users.kk-spartans = {
    # xdg-terminal-exec target for every omarchy-launch-* path.
    xdg.configFile."xdg-terminals.list".text = ''
      # Terminal emulator preference order for xdg-terminal-exec
      kitty.desktop
    '';

    # Copy-if-absent seeding, the NixOS replacement for /etc/skel: files a
    # user may intentionally edit (toggles, branding) land once and are never
    # touched again. HM-owned configs are wired declaratively instead.
    home.activation.omarchySeed = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''      omarchySeed() {
        local src="$1" dst="$2"
        if [[ -e "$src" && ! -e "$dst" ]]; then
          mkdir -p "$(dirname "$dst")"
          cp -- "$src" "$dst"
        fi
      }
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: _:
          ''omarchySeed "${config.environment.sessionVariables.OMARCHY_PATH}/default/hypr/toggles/${name}" "$HOME/.local/state/omarchy/toggles/hypr/${name}"''
        ) {
          "flags.lua" = null;
          "single-window-aspect-ratio.lua" = null;
          "window-no-gaps.lua" = null;
        }
      )}
      omarchySeed "${config.environment.sessionVariables.OMARCHY_PATH}/logo.txt" "$HOME/.config/omarchy/branding/about.txt"
    '';

    # Hyprland Lua merge: bootstrap Omarchy's framework before this flake's
    # personal config. wayland.windowManager.hyprland.extraConfig is a lines
    # concatenation across modules, so mkBefore puts the bootstrap first and
    # binds/looks/rules/workspaces override afterwards — same layering as
    # upstream's hyprland.lua dofile order.
    wayland.windowManager.hyprland.extraConfig = lib.mkBefore ''
      dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

      require("default.hypr.omarchy")
    '';

    # The rendered theme palette lands in
    # ~/.local/state/omarchy/current/theme/kitty.conf (colors only); sourcing
    # it keeps kitty home-manager-owned while following theme switches.
    programs.kitty.extraConfig = lib.mkAfter ''
      # Omarchy theme palette (managed include)
      include ''${xdg.stateHome}/omarchy/current/theme/kitty.conf
    '';
  };
}
