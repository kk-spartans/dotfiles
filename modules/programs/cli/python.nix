{
  config,
  pkgs,
  inputs,
  lib,
  nvidia,
  ...
}:
{
  programs.ruff.enable = true;
  home.packages = [ pkgs.ty ];
  programs.uv.enable = true;
}
