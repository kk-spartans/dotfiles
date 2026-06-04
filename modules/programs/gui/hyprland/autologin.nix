{
  services.getty.autologinUser = "kk-spartans";
  home-manager.users.kk-spartans.wayland.windowManager.hyprland.settings.exec-once = [
    "hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"
  ];
  services.getty.extraArgs = [
    "--noclear"
  ];
}
