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

  home-manager.users.kk-spartans = {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("spotify")
        end)

        hl.bind("SUPER + A", hl.dsp.workspace.toggle_special("spotify"))

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
