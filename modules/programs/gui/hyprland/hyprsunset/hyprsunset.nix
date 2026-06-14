{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.hyprsunset ];
  xdg.configFile."hypr/hyprsunset.conf".source = ./hyprsunset.conf;

  systemd.user.services.hyprsunset = {
    Unit = {
      Description = "Hyprsunset (blue light filter)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
