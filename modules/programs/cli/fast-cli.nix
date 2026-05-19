{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.fast-cli-zig ];
  programs.fish.shellAliases.fast = "fast-cli";
}
