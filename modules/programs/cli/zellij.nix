{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false; # breaks my tty too...
    settings = {
      show_startup_tips = false;
      allow_kitty_graphics = true;
    };
  };

  catppuccin.zellij.enable = true;
}
