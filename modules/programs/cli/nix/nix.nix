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

  sops.templates."nix-extra.conf" = {
    content = ''
      access-tokens = github.com=${config.sops.placeholder.GITHUB_TOKEN}
    '';
    mode = "0444";
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."nix-extra.conf".path}
  '';

  sops.secrets.GITHUB_TOKEN = { };

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
