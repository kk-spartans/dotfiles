{
  config,
  pkgs,
  inputs,
  ...
}:
{
  catppuccin.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 0;
      resize_on_border = false;
      allow_tearing = false;
      # layout = "scrolling"; // i dont get the hype
      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      rounding_power = 2;
      active_opacity = 1.0;
      inactive_opacity = 0.9;

      shadow = {
        enabled = true;
        range = 10;
        render_power = 3;
        color = "rgba(121212ee)";
      };

      blur = {
        enabled = true;
        size = 5;
        passes = 3;
        vibrancy = 0.05;
        ignore_opacity = true;
      };
    };

    animations = {
      enabled = true;

      bezier = [
        "smoothOut, 0.36, 0, 0.66, -0.56"
        "smoothIn, 0.25, 1, 0.5, 1"
        "overshot, 0.05, 0.9, 0.1, 1.05"
        "softSnap, 0.4, 0, 0.2, 1"
        "fluent, 0.0, 0.0, 0.2, 1.0"
      ];

      animation = [
        "windows, 1, 5, overshot, popin 80%"
        "windowsIn, 1, 5, overshot, popin 80%"
        "windowsOut, 1, 4, smoothOut, popin 95%"
        "windowsMove, 1, 3, smoothIn"
        "layersIn, 1, 3, smoothIn, fade"
        "layersOut, 1, 3, smoothIn, fade"
        "fade, 1, 4, smoothIn"
        "fadeIn, 1, 4, smoothIn"
        "fadeOut, 1, 4, smoothOut"
        "fadeSwitch, 1, 4, smoothIn"
        "fadeShadow, 1, 4, smoothIn"
        "fadeDim, 1, 4, smoothIn"
        "fadeDpms, 1, 4, smoothIn"
        "workspaces, 1, 5, overshot, slidefade 30%"
        "specialWorkspace, 1, 5, overshot, slidefadevert 30%"
      ];
    };

    dwindle = {
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };
  };
}
