{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.tokscale ];

  systemd.user.services.tokscale-submit = {
    Unit = {
      Description = "Submit tokscale data daily";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.tokscale}/bin/tokscale submit";
    };
  };

  systemd.user.timers.tokscale-submit = {
    Unit = {
      Description = "Run tokscale submit daily";
    };
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
