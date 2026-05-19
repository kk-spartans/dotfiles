{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.totp-cli ];
  programs.fish.shellAliases.totp = "totp-cli";
}
