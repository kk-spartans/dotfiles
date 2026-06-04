{
  services.getty.autologinUser = "kk-spartans";
  home-manager.users.kk-spartans.wayland.windowManager.hyprland.settings.exec-once = [
    "hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"
  ];
  programs.fish.interactiveShellInit = ''
    if isatty 1
      uwsm start default
    end
  '';
  services.getty.extraArgs = [
    "--noclear"
  ];
}
