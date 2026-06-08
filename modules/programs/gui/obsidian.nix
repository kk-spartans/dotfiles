{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.users.kk-spartans.home.packages = [ pkgs.obsidian ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };
}
