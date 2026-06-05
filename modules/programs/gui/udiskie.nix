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
    wayland.windowManager.hyprland.extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("udiskie --automount --tray")
      end)
    '';
  };
}
