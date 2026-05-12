{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.geist-mono
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting.enable = true;
    hinting.style = "slight";
    subpixel.rgba = "rgb";
  };

  home-manager.users.kk-spartans = {
    fonts.fontconfig.enable = true;
  };
}
