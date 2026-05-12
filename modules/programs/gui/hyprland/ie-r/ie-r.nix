{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  xdg.configFile."ie-r/config.toml".source = ./config.toml;
  wayland.windowManager.hyprland.settings = {
    exec-once = [ "ie-r" ];
    bind = [
      "SUPER, C, exec, pkill -SIGUSR1 ie-r"
      "SUPER SHIFT, C, exec, pkill -SIGUSR2 ie-r"
    ];
  };
}
