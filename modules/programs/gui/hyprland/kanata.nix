{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      port = 6060;
      extraDefCfg = ''
        process-unmapped-keys yes
      '';
      config = ''
        (defsrc caps x d h j k l w b 4 0 v)

        (defalias
          cap (tap-hold 200 200 esc (layer-while-held nav))
        )

        (deflayer base
          @cap use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc use-defsrc
        )

        (deflayer nav
          _    bspc (layer-while-held del) left down up rght C-rght C-lft end home lsft
        )

        (deflayer del
          _    _    _      bspc      del      C-bspc    C-del     home      end       C-home    C-end     _
        )
      '';
    };
  };
}
