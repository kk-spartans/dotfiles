{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.trashy ];

  # well the data i handle isn't that important
  # context: https://github.com/oberblastmeister/trashy#should-i-alias-rmtrashy-put

  programs.fish.shellAliases.rm = "trash put";
  programs.fish.shellAliases.yeet = "command rm -rf";
}
