{ pkgs, ... }:
{
  services.activitywatch.watchers.aw-watcher-window-wayland.package = pkgs.aw-watcher-window-wayland;
}
