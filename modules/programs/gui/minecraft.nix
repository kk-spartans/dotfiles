{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    portablemc
    jdk25
  ];
}
