{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--all"
    ];
  };

  programs.fish.shellAliases.ls = "eza";
  catppuccin.eza.enable = true;
}
