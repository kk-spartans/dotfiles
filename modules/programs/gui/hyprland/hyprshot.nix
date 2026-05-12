{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    hyprshot
    satty
  ];
  wayland.windowManager.hyprland = {
    settings.bind = [
      ", Print, exec, hyprshot --freeze --mode region --clipboard-only --notif-timeout 3000"
      "SHIFT, Print, exec, hyprshot --freeze --mode region --clipboard-only --notif-timeout 3000 --raw | satty --filename -"

      "SUPER, Print, exec, hyprshot --freeze --mode window --clipboard-only --notif-timeout 3000"
      "SUPER SHIFT, Print, exec, hyprshot --freeze --mode window --clipboard-only --notif-timeout 3000 --raw | satty --filename -"
    ];
    extraConfig = ''
      layerrule {
         name = hyprshot-fade
         animation = fade
         match:namespace = hyprshot
        }
    '';
  };
}
