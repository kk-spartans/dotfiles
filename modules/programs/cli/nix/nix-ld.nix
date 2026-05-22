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
      (lib.getLib openssl)
      libselinux
      glibc
      nss
      (lib.getLib config.hardware.nvidia.package)
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
