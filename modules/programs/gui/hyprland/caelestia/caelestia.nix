{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = {
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      general.apps = {
        terminal = [ "kitty" ];
        explorer = [ "nautilus" ];
      };
    };
    cli = {
      enable = true;
    };
  };
}
