{
  config,
  pkgs,
  inputs,
  lib,
  pc,
  ...
}:
{
  imports = lib.optionals pc [
    ../user/gtk/gtk.nix
    ../programs/gui/gui.nix
  ];
}
