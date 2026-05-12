{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.helium.homeModules.helium
  ];

  programs.helium.enable = true;
}
