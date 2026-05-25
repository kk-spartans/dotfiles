{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.kanata ];
  xdg.configFile."kanata/config.kbd".text = ''
    (defcfg process-unmapped-keys yes)

    (defsrc caps h j k l w b 4 0 v)

    (defalias
      cap (tap-hold 200 200 esc (layer-while-held nav))
    )

    (deflayer base
      @cap use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc
    )

    (deflayer nav
      _    left        down      up       rght      C-rght    C-lft     end       home      lsft
    )
  '';
}
