{ config, pkgs, ... }:
let
  tokscale = pkgs.writeShellApplication {
    name = "tokscale";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      exec bunx tokscale@latest "$@"
    '';
  };
in
{
  home.packages = [ tokscale ];

  systemd.user.services.tokscale-submit = {
    Unit = {
      Description = "Submit tokscale data daily";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${tokscale}/bin/tokscale submit";
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
