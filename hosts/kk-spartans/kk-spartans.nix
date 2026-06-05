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
      {
        output = "HDMI-A-1";
        mode = "1920x1080@100.00Hz";
        position = "1920x0";
        scale = 1;
      }
      {
        output = "eDP-1";
        mode = "1920x1080@60.00Hz";
        position = "0x0";
        scale = 1;
      }
    ];
    workspace_rule = [
      {
        workspace = "1";
        monitor = "HDMI-A-1";
        default = true;
        persistent = false;
      }
      {
        workspace = "2";
        monitor = "HDMI-A-1";
        persistent = false;
      }
      {
        workspace = "3";
        monitor = "HDMI-A-1";
        persistent = false;
      }
      {
        workspace = "4";
        monitor = "HDMI-A-1";
        persistent = false;
      }
      {
        workspace = "5";
        monitor = "HDMI-A-1";
        persistent = false;
      }
      {
        workspace = "6";
        monitor = "eDP-1";
        default = true;
        persistent = false;
      }
      {
        workspace = "7";
        monitor = "eDP-1";
        persistent = false;
      }
      {
        workspace = "8";
        monitor = "eDP-1";
        persistent = false;
      }
      {
        workspace = "9";
        monitor = "eDP-1";
        persistent = false;
      }
      {
        workspace = "10";
        monitor = "eDP-1";
        persistent = false;
      }
    ];
  };
}
