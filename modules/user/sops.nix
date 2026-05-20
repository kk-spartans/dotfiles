{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/kk-spartans/.config/sops/age/keys.txt";
  };

  home-manager.users.kk-spartans = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    home.packages = [ pkgs.sops ];

    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/kk-spartans/.config/sops/age/keys.txt";
    };
  };
}
