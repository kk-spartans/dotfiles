{
  config,
  pkgs,
  inputs,
  ...
}:
{
  catppuccin.hyprland.enable = false; # Omarchy theme engine owns Hyprland colors

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.curve("smoothOut", { type = "bezier", points = {{ 0.36, 0 }, { 0.66, -0.56 }} })
      hl.curve("smoothIn", { type = "bezier", points = {{ 0.25, 1 }, { 0.5, 1 }} })
      hl.curve("overshot", { type = "bezier", points = {{ 0.05, 0.9 }, { 0.1, 1.05 }} })
      hl.curve("softSnap", { type = "bezier", points = {{ 0.4, 0 }, { 0.2, 1 }} })
      hl.curve("fluent", { type = "bezier", points = {{ 0.0, 0.0 }, { 0.2, 1.0 }} })

      hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 95%" })
      hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "smoothIn" })
      hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "smoothIn", style = "fade" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "smoothIn", style = "fade" })
      hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "smoothOut" })
      hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeDpms", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slidefade 30%" })
      hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "overshot", style = "slidefadevert 30%" })
    '';

    settings.config = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      animations = {
        enabled = true;
      };

      decoration = {
        rounding = 16; # curved island aesthetic
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
  };
}
