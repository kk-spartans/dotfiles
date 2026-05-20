{
  config,
  pkgs,
  inputs,
  ...
}:
let
  hf = pkgs.writeShellApplication {
    name = "hf";
    runtimeInputs = [ pkgs.uv ];
    text = ''
      exec uvx hf "$@"
    '';
  };
in
{
  home.packages = [ hf ];
}
