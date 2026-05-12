{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  environment.shells = with pkgs; [
    # polkit needs it
    bashInteractive
    fish
  ];

  environment.systemPackages = with pkgs; [
    gsettings-desktop-schemas
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    gnome-keyring
    seahorse
    libsecret
    glib
    polkit_gnome
  ];

  environment.pathsToLink = [
    "/share/glib-2.0/schemas"
    "/etc/xdg"
  ];
}
