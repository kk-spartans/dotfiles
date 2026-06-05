{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.hyprsunset ];
  xdg.configFile."hypr/hyprsunset.conf".source = ./hyprsunset.conf;
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("hyprsunset")
    end)
  '';
}
