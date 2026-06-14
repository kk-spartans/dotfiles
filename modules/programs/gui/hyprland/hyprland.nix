{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./sddm.nix
    ./kanata.nix
    ./udiskie.nix
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

      # ./cava/cava.nix # hyprwinwrap is broken
    ];

    home.packages = with pkgs; [
      hyprshutdown
      playerctl
    ];

    systemd.user.services.mpris-proxy = {
      Unit = {
        Description = "MPRIS proxy";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.playerctl}/bin/mpris-proxy";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
