{
  services.getty.autologinUser = "kk-spartans";
  home-manager.users.kk-spartans.wayland.windowManager.hyprland.settings.exec-once = [
    "hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"
  ];
  home-manager.users.kk-spartans.programs.fish.loginShellInit = ''
    tty | rg -q "/dev/tty1"
    if test $status -eq 1
      uwsm start default
    end
  '';
  services.getty.extraArgs = [
    "--noclear"
  ];
}
