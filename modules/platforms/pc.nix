{
  config,
  pkgs,
  inputs,
  lib,
  pc,
  ...
}:
{
  imports = lib.optionals pc [
    ../user/gtk/gtk.nix
    ../programs/gui/gui.nix
    inputs.hex.nixosModules.hex
  ];

  home-manager.users.kk-spartans = lib.mkIf pc {
    imports = [ inputs.hex.homeManagerModules.hex ];
    programs.hex = {
      enable = true;
      autostart = true;
      systemdTarget = "graphical-session.target";
      # Hex dictation toggle is bound to CTRL + Space in
      # modules/programs/gui/hyprland/hypr/binds.nix (hl.bind).
      # hex 3.3.0 has a failing test (meetings.opencode_model names no setting)
      package = inputs.hex.packages.${pkgs.stdenv.hostPlatform.system}.hex.overrideAttrs (old: {
        doCheck = false;
      });
      # Declarative settings (see hex docs/nix.md). Uncomment and adjust:
      # shortcut = "control+option+space";
      # model = "parakeet_v3";
      # language = "en";
      # installModel = true;
      # settings = {
      #   shortcut_mode = "toggle";
      #   sound_effect_volume = 0.4;
      #   paste_with_shift = true;
      #   "meetings.enabled" = true;
      # };
    };
  };

  # The wifi tray icon. blueman 2.4 dropped its NetworkManager applet, and
  # nixpkgs dropped networking.networkmanager.applet along with it, so
  # nm-applet gets wired up by hand here. Without it the desktop host has
  # a bluetooth tray icon and no network one. Desktop hosts only --
  # mac-pro imports this module with pc = false and gets nothing.
  systemd.user.services.nm-applet = lib.mkIf pc {
    description = "NetworkManager tray applet";
    documentation = [ "https://networkmanager.pages.freedesktop.org/NetworkManager/Applet/" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    restartTriggers = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.networkmanagerapplet;
      Restart = "on-failure";
      RestartSec = 5;
      Slice = "app.slice";
    };
  };
}
