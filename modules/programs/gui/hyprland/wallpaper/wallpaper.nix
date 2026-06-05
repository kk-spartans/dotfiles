{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    awww
  ];

  xdg.configFile."hypr/hyprlock/wall" = {
    source = ./wall;
    executable = true;
  };

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("~/.config/hypr/hyprlock/wall")
    end)
  '';
}
