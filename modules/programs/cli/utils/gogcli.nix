{ config, pkgs, inputs, ... }:
let
  gogcli = inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.gogcli;
in
{
  home.packages = [
    gogcli
    pkgs.google-cloud-sdk
  ];
}
