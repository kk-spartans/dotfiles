{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    gogcli
    google-cloud-sdk
  ];
}
