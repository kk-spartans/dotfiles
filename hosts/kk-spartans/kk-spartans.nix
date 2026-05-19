{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [ "resume=/dev/disk/by-label/swap" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
