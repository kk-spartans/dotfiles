{
  pkgs,
  inputs,
  ...
}:
{
  programs.hyprlock.enable = true; # can't set settings here...?
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, L, exec, hyprctl dispatch dpms on && hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"
  ];
  xdg.configFile."hypr/hyprlock/hyprlock.conf".source = ./hyprlock.conf;
  xdg.configFile."hyprlock.conf".source = ./hyprlock.conf;
  xdg.configFile."hypr/hyprlock/current-song.sh" = {
    source = ./current-song.sh;
    executable = true;
  }; # can't use {{title}} in hyprlang

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
      lock_cmd = hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf
      before_sleep_cmd = hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf
    }

    listener {
        timeout = 90
        on-timeout = hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf
    }
  '';
}
