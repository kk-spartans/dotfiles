{ pkgs, config, ... }:
{
  sops.secrets.LASTFM_API_KEY = { };

  services.activitywatch.watchers.aw-watcher-lastfm = {
    package = pkgs.stdenvNoCC.mkDerivation {
      pname = "aw-watcher-lastfm";
      version = "0.5.1";
      src = pkgs.fetchzip {
        url = "https://github.com/0xbrayo/aw-watcher-lastfm/releases/download/v0.5.1/aw-watcher-lastfm-linux.zip";
        hash = "sha256-ODHJDjOEG956skxToUm7Wr8Lq8TTZTNCeyHaLzNrZ6c=";
      };

      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      buildInputs = with pkgs; [
        openssl
        zlib
        stdenv.cc.cc.lib
      ];

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 "$src/aw-watcher-lastfm" "$out/bin/aw-watcher-lastfm"
        runHook postInstall
      '';
    };
    executable = "aw-watcher-lastfm";
  };

  xdg.configFile."activitywatch/aw-watcher-lastfm/config.yaml".text = ''
    username: kk-spartans
    apikey: ${config.sops.secrets."LASTFM_API_KEY".path}
    polling_interval: 10
  '';
}
