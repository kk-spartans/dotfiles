{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    awww
  ];

  xdg.configFile."hypr/hyprlock/wall" = {
    source = ./wall;
    executable = true;
  };

  wayland.windowManager.hyprland.settings.exec-once = [ "~/.config/hypr/hyprlock/wall" ];
}
