{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  version = "5.0.3";
  system = pkgs.stdenv.hostPlatform.system;
  arch =
    {
      x86_64-linux = "x86_64";
      aarch64-linux = "aarch64";
      i686-linux = "i686";
    }
    .${system} or (throw "portablemc: unsupported platform ${system}");
in
{
  home.packages = [
    pkgs.jdk21
    pkgs.flite

    (pkgs.stdenv.mkDerivation {
      pname = "portablemc";
      inherit version;

      src = pkgs.fetchurl {
        url = "https://github.com/theorzr/portablemc/releases/download/v${version}/portablemc-${version}-linux-${arch}-gnu.tar.gz";
        sha256 = "cc1ca6b0529ac4df552ba794c79c0a40f979b7549124753f0e4446c2b71d81f5";
      };

      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      buildInputs = [
        pkgs.stdenv.cc.cc
        pkgs.openssl
        pkgs.systemd
      ];

      installPhase = ''
        mkdir -p $out/bin
        cp -r * $out/
        chmod +x $out/portablemc
        mv $out/portablemc $out/portablemc-real

        cat > $out/bin/portablemc <<EOF
        #!${pkgs.bash}/bin/bash
        export LD_LIBRARY_PATH=${
          lib.makeLibraryPath [
            pkgs.systemd
            pkgs.libglvnd
          ]
        }:''${LD_LIBRARY_PATH:-}
        "$out/portablemc-real" "\$@"

        EOF

        chmod +x $out/bin/portablemc
      '';
    })
  ];
}
