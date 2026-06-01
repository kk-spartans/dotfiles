{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./sddm.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  home-manager.users.kk-spartans = {
    wayland.windowManager.hyprland.systemd.enable = false; # conflicts with uwsm

    imports = [
      ./hyprshot.nix
      ./kanata.nix
      ./vicinae.nix
      # ./hypridle.nix

      ./hypr/binds.nix
      ./hypr/looks.nix
      ./hypr/workspaces.nix
      ./hypr/rules.nix
      # ./hypr/plugins.nix

      ./waybar/waybar.nix
      ./wallpaper/wallpaper.nix
      ./swaync/swaync.nix
      ./snappy-switcher/snappy-switcher.nix
      ./ie-r/ie-r.nix
      ./hyprlock/hyprlock.nix
      ./hyprsunset/hyprsunset.nix

      # ./cava/cava.nix // extremely broken right now
    ];

    home.packages = [ pkgs.hyprshutdown ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      settings = {
        exec-once = [ "mpris-proxy" ];
      };
    };
  };
}
