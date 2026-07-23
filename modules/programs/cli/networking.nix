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
    # mitmproxy # broken
    iperf3
    dig
  ];
}
