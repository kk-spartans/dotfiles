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

  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("uwsm app -- vicinae toggle"))
    hl.bind("SUPER + V", hl.dsp.exec_cmd("uwsm app -- vicinae 'vicinae://launch/clipboard/history'"))
    hl.bind("SUPER + SEMICOLON", hl.dsp.exec_cmd("uwsm app -- vicinae 'vicinae://launch/core/search-emojis'"))

    hl.layer_rule({
      name = "vicinae-fade",
      match = { namespace = "vicinae" },
      blur = true,
      ignore_alpha = 0,
      animation = "fade",
    })
  '';

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
          name = "evergarden-summer";
          icon_theme = "default";
        };
        dark = {
          name = "tokyo-night";
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
            code.alias = "code";
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
