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
  ];

  home-manager.users.kk-spartans = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
      inputs.zen-browser.homeModules.default
      inputs.vicinae.homeManagerModules.default

      ./kitty.nix
      ./minecraft.nix
      ./opencode.nix
      ./fish.nix
      ./vscode/vscode.nix
      ./helium.nix
      ./discord.nix
      ./activitywatch/activitywatch.nix
      ./zen-browser/zen-browser.nix
    ];

    home.packages = with pkgs; [
      t3code
      blender
      audacity
      brightnessctl
      libreoffice
      playerctl
      alsa-utils
      nautilus
      lutgen
      usbutils
      aircrack-ng
      nmap
      gimp
      obsidian
    ];
  };
}
