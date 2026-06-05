{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  xdg.configFile."ie-r/config.toml".source = ./config.toml;
  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("ie-r")
      end)

      hl.bind("SUPER + C", hl.dsp.exec_cmd("pkill -SIGUSR1 ie-r"))
      hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("pkill -SIGUSR2 ie-r"))
    '';
  };
}
