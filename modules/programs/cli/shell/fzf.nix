{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.fzf = {
    enable = true;
    # tmux.enableShellIntegration = true; # i might not use tmux, i dont care
  };

  catppuccin.fzf.enable = true;
}
