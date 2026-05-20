{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs = { git.settings = { delta = {
    hyperlinks = true;
    line-numbers = true;
    navigate = true;
    side-by-side = true;
  }; 
core.pager = "delta";
interactive.diffFilter = "delta --color-only";
  }; 
delta.enable = true;
  };

  catppuccin.delta.enable = true;
}
