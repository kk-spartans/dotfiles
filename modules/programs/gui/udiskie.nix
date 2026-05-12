{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  home-manager.users.kk-spartans = {
    home.packages = [ pkgs.udiskie ];
    wayland.windowManager.hyprland.settings.exec-once = [ "udiskie --automount --tray" ];
  };
}
