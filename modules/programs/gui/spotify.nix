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
      settings = {
        bind = [ "SUPER, A, togglespecialworkspace, spotify" ];
        exec-once = [ "spotify" ];
      };
      extraConfig = ''
                windowrule {
                  name = spotify
                  match:class = ^(spotify)$
                  workspace = special:spotify silent
        	  fullscreen = true;
                }
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
