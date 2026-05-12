{
  pkgs,
  inputs,
  lib,
  laptop,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf laptop {
      home.packages = [ pkgs.hypridle ];
      wayland.windowManager.hyprland.settings.exec-once = [ "hypridle" ];
      xdg.configFile."hypr/hypridle.conf".text = ''
        listener {
            timeout = 30
            on-timeout = brightnessctl -s set 0
            on-resume = brightnessctl -r
        }

        listener { 
            timeout = 32
            on-timeout = brightnessctl -d tpacpi::kbd_backlight -s set 0
            on-resume = brightnessctl -d tpacpi::kbd_backlight -r
        }

        listener {
            timeout = 60
            on-timeout = hyprctl dispatch dpms off
            on-resume = hyprctl dispatch dpms on
        }

        listener {
            timeout = 1800
            on-timeout = systemctl hibernate
        }
      '';
    })
  ];
}
