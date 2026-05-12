{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.xtra-dispatchers
      inputs.hyprland-easymotion.packages.${pkgs.stdenv.hostPlatform.system}.hyprland-easymotion
    ];

    settings.plugin = {
      hyprexpo = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgb(245, 194, 231)";
        workspace_method = "center current";
        gesture_distance = 300;
        skip_empty = true;
      };

      # hyprscrolling = {
      #   column_width = 0.7;
      #   fullscreen_on_one_column = false;
      # };

      # hyprtrails = { // broken on latest version
      #   color = "rgba(89b4fa99)";
      # };

      easymotion = {
        textsize = 100;
        textcolor = "rgba(000000ff)";
        bgcolor = "rgba(27BADBff)";
        blur = 1;
        blurA = 1.0;
        xray = 0;
        textfont = "SF Pro";
        textpadding = 10;
        bordersize = 0;
        bordercolor = "rgba(ffffffff)";
        rounding = 20;
        fullscreen_action = "none";
        motionkeys = "abcdefghijklmnopqrstuvwxyz1234567890";
        motionlabels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        only_special = true;
      };
    };
  };
}
