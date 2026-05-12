{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.settings.exec-once = [ "opencode serve --port 6767 --hostname 0.0.0.0" ];
  programs.fish.shellAliases.oc = "opencode attach localhost:6767 --dir .";
}
