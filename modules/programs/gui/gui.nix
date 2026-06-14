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
    ./spotify.nix
    ./android.nix
    ./wireshark.nix
    ./bluetooth.nix
    ./obs.nix
    ./minecraft.nix
    ./printing.nix
  ];

  home-manager.users.kk-spartans = {
    imports = [
      # ./activitywatch/activitywatch.nix
      ./vscode/vscode.nix
      ./zen-browser/zen-browser.nix

      ./kitty.nix
      ./fish.nix
      ./helium.nix
      ./discord.nix
      ./files.nix
    ];

    home.packages = with pkgs; [
      # t3code # takes up 8gb worth of nix derivations?
      blender
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
      obsidian
    ];
  };
}
