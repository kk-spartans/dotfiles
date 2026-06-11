{
  config,
  pkgs,
  inputs,
  lib,
  nvidia,
  ...
}:
{
  home.packages = with pkgs; [
    (if nvidia then xmrig-cuda else xmrig)
    monero-cli
  ];
}
