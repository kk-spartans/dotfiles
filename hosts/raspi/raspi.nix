{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    inputs.spartans.nixosModules.spartans
    ./disko.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # Trust the gateway CA so *.spartans names work from here too. Names resolve
  # because Tailscale points the tailnet at the gateway's resolver; this is only
  # the certificate that makes the connection to it trusted.
  spartans = {
    enable = true;
    caCertificate = ./../../certs/spartans-root.crt;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
