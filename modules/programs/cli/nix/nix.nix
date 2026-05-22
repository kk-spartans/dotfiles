{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./nix-ld.nix ];

  home-manager.users.kk-spartans.home.packages = with pkgs; [
    treefmt
    nixfmt
    nix-index
    nix-du
    nix-tree
  ];
}
