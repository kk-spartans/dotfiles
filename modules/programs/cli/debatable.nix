{
  config,
  lib,
  pkgs,
  inputs,
  minimal,
  ...
}:
{
  programs.debatable = {
    enable = true;
    enableFishIntegration = true;
  };
}
