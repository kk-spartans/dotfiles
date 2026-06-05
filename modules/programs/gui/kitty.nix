{
  config,
  pkgs,
  inputs,
  ...
}:
{
  catppuccin.kitty.enable = true;

  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + Q", hl.dsp.exec_cmd("uwsm app -- kitty"))
  '';

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "GeistMono Nerd Font";
      font_size = 13;

      disable_ligatures = false;
      enable_audio_bell = false;

      shell = "fish";
      shell_integration = "no-cursor";
      allow_remote_control = true;

      cursor_shape = "beam";
      cursor_shape_unfocused = "unchanged";
      cursor_blink_interval = 0;
      cursor_trail = 1;

      remember_window_size = false;
      window_padding_width = 4;
      confirm_os_window_close = 0;

      background_opacity = 0.6;
      scrollbar_handle_opacity = 0;
      scrollbar_track_opacity = 0;
      scrollbar_track_hover_opacity = 0;

      background = "#000000";
    };

    extraConfig = ''
      map ctrl+shift+c copy_to_clipboard
      map ctrl+v paste_from_clipboard
    '';
  };
}
