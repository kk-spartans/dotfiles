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

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("snappy-switcher --daemon")
      end)

      hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next"))
      hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev"))
    '';
  };
}
