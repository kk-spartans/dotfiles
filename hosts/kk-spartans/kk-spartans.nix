{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [ "resume=/dev/disk/by-label/swap" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  home-manager.users.kk-spartans.wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,1920x1080@60.00Hz,0x0,1"
    "HDMI-A-1,1920x1080@100.00Hz,0x1920,1"
  ];
}
