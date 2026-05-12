{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.cava ];

  xdg.configFile."cava/config".source = ./config;
  xdg.configFile."hypr/hyprwinwrap/kitty.bg.conf".source = ./kitty.bg.conf;
  xdg.configFile."hypr/hyprwinwrap/cava.sh" = {
    source = ./cava.sh;
    executable = true;
  };

  catppuccin.cava.enable = true;

  wayland.windowManager.hyprland = {
    plugins = [ inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap ];

    extraConfig = ''
      windowrule {
        name = kitty-bg-no-effects
        match:class = ^(kitty-bg)$
        no_blur = 1
        no_shadow = 1
        rounding = 0
        render_unfocused = 1
      }
    '';

    settings.exec-once = [
      "kitty -c ~/.config/hypr/hyprwinwrap/kitty.bg.conf --class kitty-bg ~/.config/hypr/hyprwinwrap/cava.sh"
    ];
    settings.plugin.hyprwinwrap = {
      class = "kitty-bg";

      pos_x = 25;
      pos_y = 30;

      size_x = 40;
      size_y = 70;
    };
  };
}
