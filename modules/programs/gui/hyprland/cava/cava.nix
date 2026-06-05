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

    settings = {
      plugin.hyprwinwrap = {
        class = "kitty-bg";

        pos_x = 25;
        pos_y = 30;

        size_x = 40;
        size_y = 70;
      };
    };

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("kitty -c ~/.config/hypr/hyprwinwrap/kitty.bg.conf --class kitty-bg ~/.config/hypr/hyprwinwrap/cava.sh")
      end)

      hl.window_rule({
        name = "kitty-bg-no-effects",
        match = { class = "^(kitty-bg)$" },
        no_blur = true,
        no_shadow = true,
        rounding = 0,
        render_unfocused = true,
      })
    '';
  };
}
