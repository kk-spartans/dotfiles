{
  config,
  pkgs,
  inputs,
  minimal,
  ...
}:
{
  imports = [
    (import ./bun.nix).module
    ./javascript.nix
    ./rust.nix
    ./python.nix
  ];

  home.packages = with pkgs; [
    cloc
    perl
    devenv
  ];

  programs.go.enable = true;
  programs.neovim.enable = true;
}
