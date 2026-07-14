{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.ruff.enable = true;
  home.packages = [ pkgs.ty ];
  programs.uv.enable = true;
}
