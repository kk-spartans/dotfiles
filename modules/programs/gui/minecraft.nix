{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  environment.etc."xdg/alsoft.conf".text = ''
    drivers=pipewire,pulse,alsa,
  '';

  programs.nix-ld.libraries = with pkgs; [
    flite
    openal
  ];

  home-manager.users.kk-spartans.home.packages = with pkgs; [
    jdk25
    portablemc
  ];
}
