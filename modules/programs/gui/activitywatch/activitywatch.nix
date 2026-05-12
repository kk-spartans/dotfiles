{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./window-wayland.nix
    ./netstatus.nix
    ./lastfm.nix
    ./lid.nix
    # ./utilization.nix // broken, don't really need it
    # ./input.nix // broken on wayland
  ];

  programs.vscode.profiles.default.extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "aw-watcher-vscode";
      publisher = "activitywatch";
      version = "0.5.0";
      sha256 = "sha256-OrdIhgNXpEbLXYVJAx/jpt2c6Qa5jf8FNxqrbu5FfFs=";
    }
  ];

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
  };

  systemd.user.targets.activitywatch.Install.WantedBy = lib.mkForce [ "graphical-session.target" ];

  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
    "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
  ];
}
