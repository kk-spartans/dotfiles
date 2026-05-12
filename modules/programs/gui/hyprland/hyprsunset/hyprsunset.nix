{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.hyprsunset ];
  xdg.configFile."hypr/hyprsunset.conf".source = ./hyprsunset.conf;
  wayland.windowManager.hyprland.settings.exec-once = [ "hyprsunset" ];
}
