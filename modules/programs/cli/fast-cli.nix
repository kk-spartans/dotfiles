{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ pkgs.totp-cli-zig ];
  programs.fish.shellAliases.fast = "fast-cli";
}
