{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      libselinux
      glibc
      nss
    ];
  };

  environment.systemPackages = with pkgs; [
    steam-run
    gnumake
    pkg-config
    autoconf
    automake
    libtool
  ];
}
