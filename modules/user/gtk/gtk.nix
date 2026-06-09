{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./auth.nix
    ./theme.nix
  ];

  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gnome-keyring ];

  security.polkit.enable = true;

  programs.seahorse.enable = true;
  programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  home-manager.users.kk-spartans = {
    dconf.enable = true;

    home.packages = with pkgs; [
      gtk3
      gsettings-desktop-schemas
      glib
      keepassxc
    ];
  };
}
