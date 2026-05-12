{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.bun.enable = true;
  programs.npm.enable = true; # why does is it npm instead of node?

  home.packages = with pkgs; [
    deno
    pnpm
  ];
}
