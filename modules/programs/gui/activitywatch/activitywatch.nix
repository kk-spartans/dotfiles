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
    ./vscode.nix
  ];

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
  };

  systemd.user.targets.activitywatch.Install.WantedBy = lib.mkForce [ "graphical-session.target" ];

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
      hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    end)
  '';
}
