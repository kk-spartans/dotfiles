{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.users.kk-spartans.home.packages = [ pkgs.obsidian ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 2097152;
    "fs.inotify.max_user_instances" = 4096;
    "fs.inotify.max_queued_events" = 65536;
  };
}
