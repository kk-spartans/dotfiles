{
  config,
  pkgs,
  inputs,
  ...
}:

# i never saw the sddm default theme
# i didn't even know how sddm worked
# i just knew it launched on boot and started my compositor instead of me doing it thru the tty

# but one day, i broke the theme
# and i saw a screen that looked extremely familiar:
# almost all enterprises (gas stations, supermarkets, whatever) running linux use sddm.

# a peice of legacy software was making its way into my computer
# i had to nuke it.

{
  imports = [
    ./autologin.nix # i feel its better importing it here since they're mutually exclusive
  ];

  programs.hyprland.withUWSM = true;
  services.displayManager.sddm.wayland.enable = false; # you dont need one, do you? save some battery

  services.displayManager.sddm = {
    enable = false; # same here
    theme = "pixie";
    package = pkgs.kdePackages.sddm;

    extraPackages = [
      pkgs.kdePackages.qtdeclarative
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qt5compat
      pkgs.kdePackages.breeze
    ];

    settings = {
      Theme = {
        CursorTheme = "breeze_cursors";
        CursorSize = "32";
      };

      General = {
        CursorTheme = "breeze_cursors";
        CursorSize = "32";
      };
    };
  };

  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "pixie-sddm";
      src = pkgs.fetchFromGitHub {
        owner = "xCaptaiN09";
        repo = "pixie-sddm";
        rev = "main";
        hash = "sha256-1PDWX8bJfc0HYMW9MsxWwDXDoYy5aaehUWr7FW3yR9U=";
      };
      installPhase = "
        mkdir -p $out/share/sddm/themes/pixie
        cp -r * $out/share/sddm/themes/pixie/
      ";
    })
  ];
  home-manager.users.kk-spartans = {
    xdg.configFile."uwsm/env".text = ''
      export AQ_DRM_DEVICES=/dev/dri/card1
      export XCURSOR_THEME=macOS
      export HYPRCURSOR_THEME=macOS
      export XCURSOR_SIZE=32
      export HYPRCURSOR_SIZE=32
      export LIBVA_DRIVER_NAME=nvidia
      export XDG_SESSION_TYPE=wayland
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export QT_QPA_PLATFORMTHEME=gtk3
      export QT_STYLE_OVERRIDE=adwaita-dark
      export QT_FONT_DPI=96
      export GSETTINGS_SCHEMA_DIR=${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas
    '';
  };
}
