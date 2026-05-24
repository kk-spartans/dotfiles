{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.kanata ];
  wayland.windowManager.hyprland.settings.exec-once = [
    "sudo kanata -c ~/.config/kanata/config.kbd"
  ];
  xdg.configFile."kanata/config.kbd".text = ''
      (defcfg
      process-unmapped-keys yes
      concurrent-tap-hold true
    )

    (defsrc
      caps i d h j k l b w 4 0 v
    )

    (deflayer base
      ;; caps taps Escape; hold caps for nav motions
      (tap-hold-press 0 200 esc (layer-while-held nav))
      i
      bspc
      h
      j
      k
      l
      b
      w
      4
      0
      v
    )

    (deflayer nav
      _ _ XX left down up right C-left C-right end home (layer-while-held visual)
    )

    (deflayer visual
      _ _ XX S-left S-down S-up S-right C-S-left C-S-right S-end S-home _
    )

  '';
}
