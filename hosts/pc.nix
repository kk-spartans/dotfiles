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
    ../modules/user/gtk/gtk.nix
    ../modules/programs/gui/gui.nix
  ];
}
