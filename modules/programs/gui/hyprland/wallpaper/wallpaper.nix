{ pkgs, lib, ... }:
let
  wallBundle = pkgs.stdenv.mkDerivation {
    name = "wall-bundle";

    src = ./.;

    nativeBuildInputs = with pkgs; [
      bun
      makeWrapper
    ];

    dontStrip = true;
    dontPatchELF = true;

    buildPhase = ''
      bun build ./wall.ts --compile --minify --outfile wall
    '';

    installPhase = ''
      mkdir -p $out/libexec $out/bin
      cp wall $out/libexec/wall

      makeWrapper $out/libexec/wall $out/bin/wall \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.awww
            pkgs.playerctl
            pkgs.imagemagick
          ]
        }
    '';
  };
in
{
  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "awww wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.wall = {
    Unit = {
      Description = "Dynamic wallpaper from Spotify album art";
      PartOf = [ "graphical-session.target" ];
      After = [
        "graphical-session.target"
        "awww-daemon.service"
      ];
      Requires = [ "awww-daemon.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${wallBundle}/bin/wall";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
