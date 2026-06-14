{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  xdg.configFile."ie-r/config.toml".source = ./config.toml;
  systemd.user.services.ie-r = {
    Unit = {
      Description = "ie-r";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ie-r";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.bind("SUPER + C", hl.dsp.exec_cmd("pkill -SIGUSR1 ie-r"))
      hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("pkill -SIGUSR2 ie-r"))
    '';
  };
}
