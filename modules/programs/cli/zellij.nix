{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
      allow_kitty_graphics = true;
    };
  };

  catppuccin.zellij.enable = true;

  programs.fish.interactiveShellInit = ''
    if not set -q ZELLIJ
        zellij attach || zellij --session main
    end
  '';
}
