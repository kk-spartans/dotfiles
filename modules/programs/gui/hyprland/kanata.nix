{ pkgs, lib, ... }:

let
  waywarp = import ./waywarp/waywarp.nix { inherit pkgs lib; };
in
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

  home-manager.users.kk-spartans = {
    home.packages = [
      waywarp
      pkgs.ydotool
    ];

    xdg.configFile."waywarp/config".text = ''
      # waywarp config — Catppuccin Mocha
      hint_bg=#1e1e2ecc
      hint_fg=#f5c2e7ff
      hint_font=monospace
      hint_size=20
      hint_border_radius=8.0
      hint_chars=asdfghjklqwertzxv
      refinement_passes=1
      exit_on_select=false

      on_select_cmd=hyprctl dispatch movecursor {global_x} {global_y} && ydotool click 0xC0
      on_exit_cmd=

      key_left=h,Left
      key_right=l,Right
      key_up=k,Up
      key_down=j,Down
      key_shift=Shift_L,Shift_R
      key_ctrl=Control_L,Control_R
      key_click_left=m,f,Return
      key_click_right=period,slash
      key_click_middle=comma,minus
      key_scroll_up=w
      key_scroll_down=s
      key_exit=Escape,q,Q
    '';

    wayland.windowManager.hyprland.extraConfig = ''
      -- waywarp — keyboard-driven cursor control
      hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd("waywarp --normal"))
      hl.bind("SUPER + ALT + X", hl.dsp.exec_cmd("waywarp"))
      hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("waywarp --normal"))
      hl.bind("SUPER + ALT + G", hl.dsp.exec_cmd("waywarp"))
      hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("waywarp"))
      hl.bind("SUPER + ALT + H", hl.dsp.exec_cmd("waywarp --normal"))
    '';
  };
}
