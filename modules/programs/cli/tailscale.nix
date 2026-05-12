{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.secrets.TS_AUTHKEY = { };

  services.tailscale = {
    enable = true;
    authKeyFile = /run/secrets/TS_AUTHKEY;
  };
}
