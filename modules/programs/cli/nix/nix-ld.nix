{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.pathsToLink = [ "/sbin" ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      (lib.getLib openssl)
      (lib.getLib systemd)
      libselinux
      glibc
      nss
      nspr
      expat
      glib
      cups
      libdrm
      libxkbcommon
      libxcomposite
      libxdamage
      libxrandr
      libxfixes
      libxext
      libxrender
      mesa
      pango
      cairo
      freetype
      fontconfig
      harfbuzz
      at-spi2-atk
      atk
      pulseaudio
      alsa-lib
      pcre
      elfutils
      libffi
      dbus
      libpng
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
