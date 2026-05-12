{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.delta.enable = true;

  programs.git.settings.delta = {
    hyperlinks = true;
    line-numbers = true;
    navigate = true;
    side-by-side = true;
  };

  catppuccin.delta.enable = true;
}
