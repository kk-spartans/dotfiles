{
  config,
  lib,
  pkgs,
  inputs,
  minimal,
  ...
}:
{
  home-manager.users.kk-spartans = {
    home.packages =
      with pkgs;
      [
        btop
      ]
      ++ (
        if minimal then
          [ ]
        else
          [
            hyperfine
            fio
            sysbench
          ]
      );

    catppuccin.btop.enable = true;

  };

  programs.usbtop.enable = if minimal then false else true;
}
