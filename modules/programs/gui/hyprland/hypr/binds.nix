{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER CTRL, T, exec, hyprctl dispatch togglefloating active && hyprctl dispatch pin active && hyprctl dispatch bringactivetotop"

      "SUPER, E, exec, uwsm app -- nautilus"
      "SUPER, Z, exec, playerctl play-pause"

      "SUPER, G, layoutmsg, togglesplit"
      # "SUPER, K, easymotion, action:hyprctl dispatch focuswindow address:{}"
      "SUPER SHIFT, W, killactive"
      "SUPER SHIFT, SPACE, togglefloating"

      ", F11, fullscreen"
      "SUPER CTRL ALT SHIFT, F10, exec, hyprctl dispatch dpms on" # for when hypridle bugs out

      "SUPER, period, layoutmsg, move +col"
      "SUPER, comma, layoutmsg, move -col"

      "SUPER, S,       togglespecialworkspace, magic"
      "SUPER SHIFT, S, movetoworkspace, special:magic"

      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up,   workspace, e-1"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bindel = [
      ", XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86MonBrightnessUp,   exec, brightnessctl -e4 -n2 set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext,  exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay,  exec, playerctl play-pause"
      ", XF86AudioPrev,  exec, playerctl previous"
    ];

    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";
      follow_mouse = 1;
      sensitivity = 0.4;

      touchpad = {
        natural_scroll = true;
        disable_while_typing = false;
      };
    };
    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };
  };
}
