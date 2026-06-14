{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    tshark
    aria2
    wget
    mitmproxy
    iperf3
    dig
  ];
}
