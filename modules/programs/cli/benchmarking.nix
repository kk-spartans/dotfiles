{
  config,
  lib,
  pkgs,
  inputs,
  minimal,
  laptop,
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
            dmidecode
            lshw
            fio
            sysbench
          ]
      )
      ++ (if laptop then [ powertop ] else [ ]);

    catppuccin.btop.enable = true;

  };

  programs.usbtop.enable = if minimal then false else true;
}
