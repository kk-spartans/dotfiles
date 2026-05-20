{
  pkgs,
  inputs,
  ...
}:
{
  nix.settings = {
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [ "uwsm app -- vicinae server" ];
      bind = [
        "SUPER, SPACE, exec, uwsm app -- vicinae toggle"
        "SUPER, V, exec, uwsm app -- vicinae \"vicinae://launch/clipboard/history\""
        "SUPER, SEMICOLON, exec, uwsm app -- vicinae \"vicinae://launch/core/search-emojis\""
      ];
    };
    extraConfig = ''
      layerrule {
         name = vicinae-fade
         blur = on
         ignore_alpha = 0
         animation = fade
         match:namespace = vicinae
        }
    '';
  };

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      theme = {
        light = {
          name = "catppuccin-frappe";
          icon_theme = "default";
        };
        dark = {
          name = "catppuccin-mocha";
          icon_theme = "default";
        };
      };
      font = {
        normal = {
          size = 14;
          family = "GeistMono Nerd Font";
        };
      };
      launcher_window = {
        opacity = 0.7;
      };
      providers = {
        applications = {
          "@dagimg-dot/vicinae-extension-player-pilot-0".entrypoints = {
            next-track.alias = "n";
            previous-track.alias = "p";
          };
          preferences = {
            defaultAction = "launch";
            launchPrefix = "uwsm app -- ";
          };
          entrypoints = {
            code.alias = "code"; # it indexes against "Visual Studio Code"
            obsidian.alias = "ob";
          };
        };
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      bluetooth
      nix
      power-profile
      npm
      protondb-search
      wiktionary
      wikipedia
      agent-skills-sh
      nerdfont-search
      hyprland-monitors
      aria2-manager
      dashboard-icons
      github
      pulseaudio
      port-killer
      awww-switcher
      hypr-keybinds
      it-tools
      player-pilot
      wifi-commander
      process-manager
    ];
  };
}
