{ config, pkgs, ... }:
let
  tokscale = pkgs.writeShellApplication {
    name = "tokscale";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      exec bunx tokscale@latest "$@"
    '';
  };
in
{
  home.packages = [ tokscale ];
}
