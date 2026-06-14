{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.bun.enable = true;
  programs.npm.enable = true; # why does is it npm instead of node?
  home.file.".npmrc".enable = false; # can't log in to npm

  home.packages = with pkgs; [
    deno
    pnpm
    aube
  ];
}
