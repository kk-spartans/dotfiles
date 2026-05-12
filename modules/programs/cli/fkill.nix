{ config, pkgs, ... }:
let
  fkill = pkgs.writeShellApplication {
    name = "fkill";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      exec bunx fkill-cli "$@"
    '';
  };
in
{
  home.packages = [ fkill ];
}
