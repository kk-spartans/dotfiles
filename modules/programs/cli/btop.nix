{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.btop ];
  catppuccin.btop.enable = true;
}
