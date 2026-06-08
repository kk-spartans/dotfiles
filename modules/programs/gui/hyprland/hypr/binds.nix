{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("hyprctl dispatch togglefloating active && hyprctl dispatch pin active && hyprctl dispatch bringactivetotop"))

      hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm app -- nautilus"))
      hl.bind("SUPER + Z", hl.dsp.exec_cmd("playerctl play-pause"))

      hl.bind("SUPER + G", hl.dsp.layout("togglesplit"))
      hl.bind("SUPER + SHIFT + W", hl.dsp.window.close())
      hl.bind("SUPER + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

      hl.bind("F11", hl.dsp.window.fullscreen())
      hl.bind("SUPER + CTRL + ALT + SHIFT + F10", hl.dsp.exec_cmd("hyprctl dispatch dpms on"))

      hl.bind("SUPER + period", hl.dsp.layout("move +col"))
      hl.bind("SUPER + comma", hl.dsp.layout("move -col"))

      hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
      hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

      hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    '';
    settings = {
      config = {
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
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
    };
  };
}
