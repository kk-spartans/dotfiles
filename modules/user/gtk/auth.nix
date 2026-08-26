{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.fprintd.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  home-manager.users.kk-spartans = {
    services.gnome-keyring.enable = true;

    # polkit agent: the Omarchy shell ships its own (plugins/polkit).

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };
}
