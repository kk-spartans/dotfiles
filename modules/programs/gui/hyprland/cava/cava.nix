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

  systemd.user.services.cava = {
    Unit = {
      Description = "Cava audio visualizer";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kitty}/bin/kitty -c %h/.config/hypr/hyprwinwrap/kitty.bg.conf --class kitty-bg %h/.config/hypr/hyprwinwrap/cava.sh";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
