{ config, pkgs, ... }:
let
  tokscale = pkgs.writeShellApplication {
    name = "tokscale";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      exec bunx tokscale "$@"
    '';
  };
in
{
  home.packages = [ tokscale ];
}
