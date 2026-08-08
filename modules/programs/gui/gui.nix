{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hyprland/hyprland.nix
    ./files.nix
    ./spotify.nix
    ./android.nix
    ./wireshark.nix
    ./bluetooth.nix
    ./obs.nix
    ./minecraft.nix
    ./printing.nix
    ./blender.nix
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "us.zoom.Zoom"
    ];
  };

  home-manager.users.kk-spartans = {

    imports = [
      # ./activitywatch/activitywatch.nix
      ./obsidian.nix
      ./vscode/vscode.nix
      ./zen-browser/zen-browser.nix

      ./kitty.nix
      ./fish.nix
      ./helium.nix
      ./discord.nix
    ];

    home.packages = with pkgs; [
      # t3code # takes up 8gb worth of nix derivations?
      gnome-network-displays
      audacity
      brightnessctl
      libreoffice
      playerctl
      alsa-utils
      lutgen
      usbutils
      aircrack-ng
      nmap
      gimp
      naps2
    ];
  };
}
