{ config, lib, pkgs, modulesPath, ... }:

{
  boot.kernelParams = [ "resume=/dev/disk/by-label/swap" ];
}
