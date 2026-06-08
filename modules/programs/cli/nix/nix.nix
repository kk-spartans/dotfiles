{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./nix-ld.nix ];
  nix = {
    gc = {
      automatic = false; # true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = false; # true;
      keep-outputs = true; # false;
      keep-derivations = true; # false;
    };
  };

  home-manager.users.kk-spartans = {
    home.packages = with pkgs; [
      treefmt
      nixfmt
      nix-index
      nix-output-monitor
      nix-du
      nix-tree
    ];
  };
}
