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
  home-manager.users.kk-spartans.wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,1920x1080@60.00Hz,0x0,1"
      "HDMI-A-1,1920x1080@100.00Hz,0x1920,0.8"
    ];
    workspace = [
      "1,monitor:HDMI-A-1,default:true,persistent:false"
      "2,monitor:HDMI-A-1,persistent:false"
      "3,monitor:HDMI-A-1,persistent:false"
      "4,monitor:HDMI-A-1,persistent:false"
      "5,monitor:HDMI-A-1,persistent:false"
      "6,monitor:eDP-1,default:true,persistent:false"
      "7,monitor:eDP-1,persistent:false"
      "8,monitor:eDP-1,persistent:false"
      "9,monitor:eDP-1,persistent:false"
      "10,monitor:eDP-1,persistent:false"
    ];
  };
}
