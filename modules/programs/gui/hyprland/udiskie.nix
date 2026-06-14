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

    systemd.user.services.udiskie = {
      Unit = {
        Description = "UDiskie (disk automounter)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.udiskie}/bin/udiskie --automount --tray";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
