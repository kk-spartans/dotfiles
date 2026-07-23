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
    ./disko.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
