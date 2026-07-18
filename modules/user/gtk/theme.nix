{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home-manager.users.kk-spartans = {
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };

    catppuccin = {
      enable = true;
      autoEnable = false;
      flavor = "mocha";
      accent = "pink";
    };

    gtk = {
      enable = true;
      font = {
        package = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro;
        name = "SF Pro";
        size = 14;
      };

      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-key-theme-name = "Default";
      };

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    };

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      name = "macOS";
      size = 24;
      package = pkgs.apple-cursor;
    };

    catppuccin.gtk.icon.enable = true;

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style = {
        package = pkgs.adwaita-qt6;
        name = "adwaita-dark";
      };
    };
  };
}
