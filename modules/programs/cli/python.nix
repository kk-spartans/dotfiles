{
  config,
  pkgs,
  inputs,
  lib,
  nvidia,
  ...
}:
{
  programs.ruff.enable = true;
  home.packages = [ pkgs.ty ];

  programs.uv = {
    enable = true;
    settings = (
      lib.mkIf nvidia {
        pip.index-url = "https://download.pytorch.org/whl/cu130";
      }
    );
  };
}
