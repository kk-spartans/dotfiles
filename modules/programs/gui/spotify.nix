{
  config,
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];

  services.snapserver = {
    enable = true;
    openFirewall = true;
    settings = {
      # Snapserver starts librespot itself and reads its raw PCM from stdout.
      stream.source = "librespot://${pkgs.librespot}/bin/librespot?name=Spotify&devicename=Snapcast&bitrate=320&codec=opus&cache=/var/lib/snapserver/librespot&params=--device-type%20speaker";
      tcp-streaming = {
        enabled = true;
        bind_to_address = "0.0.0.0";
        port = 1704;
      };
      tcp-control = {
        enabled = true;
        bind_to_address = "0.0.0.0";
        port = 1705;
      };
      http.enabled = false;
    };
  };

  # OAuth cannot run inside Snapserver's librespot stream: Snapserver consumes
  # librespot's stdout as PCM, including the printed authorization URL. Run
  # this unit once to populate the credential cache, then start Snapserver.
  systemd.services.librespot-login = {
    description = "One-time librespot OAuth login";
    conflicts = [ "snapserver.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      User = "snapserver";
      StateDirectory = "snapserver";
      ExecStart = "${pkgs.librespot}/bin/librespot --enable-oauth --oauth-port 5588 --cache /var/lib/snapserver/librespot --name Snapcast --device-type speaker --backend pipe --device /dev/null";
    };
  };

  home-manager.users.kk-spartans = {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("spotify")
        end)

        hl.bind("SUPER + A", hl.dsp.workspace.toggle_special("spotify"))
        hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("sh -c 'case $(playerctl --player=spotify volume 2>/dev/null) in 0.3*) playerctl --player=spotify volume 1.0 ;; *) playerctl --player=spotify volume 0.3 ;; esac'"))

        hl.window_rule({
          name = "spotify",
          match = { class = "^([Ss]potify)$" },
          workspace = "special:spotify silent",
          fullscreen = true,
        })

        hl.window_rule({
          name = "spotify-fallback",
          match = { initial_title = "^Spotify" },
          workspace = "special:spotify silent",
          fullscreen = true,
        })
      '';
    };

    xdg.configFile."hypr/hypridle.conf".text = ''
      # listener { 
      #     timeout = 35
      #     on-timeout = hyprctl dispatch workspace special:spotify
      #     on-resume = hyprctl dispatch togglespecialworkspace spotify
      # }
    '';
  };

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.hazy;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      spicy-lyrics
    ];
  };
}
