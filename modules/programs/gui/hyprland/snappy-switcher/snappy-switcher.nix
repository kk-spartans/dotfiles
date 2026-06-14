{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  snappy = inputs.snappy-switcher.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  xdg.configFile."snappy-switcher/config.ini".source = ./config.ini;
  home.packages = [ snappy ];
  home.activation.snappy-switcher = lib.hm.dag.entryAfter [
    "writeBoundary"
  ] "${snappy}/bin/snappy-install-config";

  systemd.user.services.snappy-switcher = {
    Unit = {
      Description = "Snappy Switcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${snappy}/bin/snappy-switcher --daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next"))
      hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev"))
    '';
  };
}
