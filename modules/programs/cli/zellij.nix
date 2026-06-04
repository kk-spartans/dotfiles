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
    tty | rg -q "/dev/tty1"
    if not set -q ZELLIJ; and test $status -eq 1
        zellij attach main || zellij --session main
    end
  '';
}
