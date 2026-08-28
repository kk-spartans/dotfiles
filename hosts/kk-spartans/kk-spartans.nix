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
    ../../modules/services/t3-server.nix
  ];

  boot.kernelParams = [ "resume=/dev/disk/by-label/swap" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # VFIO passthrough: flip BIOS to Hybrid (Discrete disables Intel 00:02.0), then set true and change flake gpu to "intel"
  my.vfio.enable = false;

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "mac-pro";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      sshUser = "kk-spartans";
      maxJobs = 24;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];
  home-manager.users.kk-spartans.home.packages = [ pkgs.kiwix-tools ];
  home-manager.users.kk-spartans.wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "HDMI-A-1";
        mode = "1920x1080@100.00Hz";
        position = "0x0";
        scale = 1;
      }
      {
        output = "eDP-1";
        mode = "1920x1080@60.00Hz";
        position = "0x1080";
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
