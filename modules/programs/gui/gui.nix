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
    ./udiskie.nix
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
      inputs.zen-browser.homeModules.default
      inputs.vicinae.homeManagerModules.default

      ./kitty.nix
      ./opencode.nix
      ./fish.nix
      ./vscode/vscode.nix
      ./helium.nix
      ./discord.nix
      ./files.nix
      ./zen-browser/zen-browser.nix

      # ./activitywatch/activitywatch.nix
    ];

    home.packages = with pkgs; [
      t3code
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
