{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services.tailscale = {
    enable = true;
    authKeyFile = ../../../secrets/tailscale; # i do not care that my secrets are in the nix store, they aren't that important.
  };
}
