{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs = {
    git.settings = {
      delta = {
        hyperlinks = true;
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };

  catppuccin.delta.enable = true;
}
