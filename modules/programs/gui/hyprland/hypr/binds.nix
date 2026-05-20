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

      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"

      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, movetoworkspace, 8"
      "SUPER SHIFT, 9, movetoworkspace, 9"
      "SUPER SHIFT, 0, movetoworkspace, 10"

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
