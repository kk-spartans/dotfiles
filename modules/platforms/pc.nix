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
  ];

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
