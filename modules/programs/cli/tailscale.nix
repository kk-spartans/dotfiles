{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  services.tailscale = {
    enable = true;
    authKeyFile = /run/secrets/TS_AUTHKEY;
  };
}
