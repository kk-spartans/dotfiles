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

  wayland.windowManager.hyprland.settings = {
    exec-once = [ "snappy-switcher --daemon" ];
    bind = [
      "ALT, Tab, exec, snappy-switcher next"
      "ALT SHIFT, Tab, exec, snappy-switcher prev"
    ];
  };
}
