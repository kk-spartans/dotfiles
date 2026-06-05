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
  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("Print", hl.dsp.exec_cmd("hyprshot --freeze --mode region --clipboard-only --notif-timeout 3000"))
    hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot --freeze --mode region --clipboard-only --notif-timeout 3000 --raw | satty --filename -"))
    hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot --freeze --mode window --clipboard-only --notif-timeout 3000"))
    hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("hyprshot --freeze --mode window --clipboard-only --notif-timeout 3000 --raw | satty --filename -"))

    hl.layer_rule({
      name = "hyprshot-fade",
      match = { namespace = "hyprshot" },
      animation = "fade",
    })
  '';
}
