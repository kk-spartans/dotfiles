{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.extraConfig = ''
    gesture = 3, horizontal, workspace

    windowrule {
      name = suppress-maximize-events
      match:class = .*
      suppress_event = maximize
    }

    windowrule {
      name = fix-xwayland-drags
      match:class = ^''$
      match:title = ^''$
      match:xwayland = true
      match:float = true match:fullscreen = false
      match:pin = false
      no_focus = true
    }

    windowrule {
      name = move-hyprland-run
      match:class = hyprland-run
      move = 20 monitor_h-120
      float = yes
    }

    windowrule {
      name = swaync-noborder
      match:class = ^(swaync)$
      border_size = 0
    }
  '';
}
