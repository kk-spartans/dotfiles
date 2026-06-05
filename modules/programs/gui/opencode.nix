{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("opencode serve --port 6767 --hostname 0.0.0.0")
    end)
  '';
  programs.fish.shellAliases.oc = "opencode attach localhost:6767 --dir .";
}
