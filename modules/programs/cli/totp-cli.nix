{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ pkgs.totp-cli ];
  programs.fish.shellAliases.totp = "totp-cli";
}
