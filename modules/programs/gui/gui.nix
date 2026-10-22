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
    ./virt-manager.nix
  ];

  programs.zoom-us.enable = true;

  # Qt 6.12's generated QML code clashes with audacity's unity build
  # (nixpkgs PR #577022, not merged yet).
  nixpkgs.overlays = [
    (final: prev: {
      audacity = prev.audacity.overrideAttrs (old: {
        postPatch = ''
          substituteInPlace muse/framework/extensions/qml/Muse/Extensions/CMakeLists.txt \
            --replace-fail 'ALIAS muse::extensions_qml' 'NO_UNITY ALIAS muse::extensions_qml'
        ''
        + (old.postPatch or "");
      });
    })
  ];

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
