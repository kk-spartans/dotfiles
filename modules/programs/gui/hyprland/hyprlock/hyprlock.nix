{
  pkgs,
  inputs,
  ...
}:
{
  programs.hyprlock.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })' && hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"))
  '';
  xdg.configFile."hypr/hyprlock/hyprlock.conf".source = ./hyprlock.conf;
  xdg.configFile."hypr/hyprlock/current-song.sh" = {
    source = ./current-song.sh;
    executable = true;
  };

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
