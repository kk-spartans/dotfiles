{ pkgs, config, inputs, ... }:
{
  sops.secrets.LASTFM_API_KEY = { };

  services.activitywatch.watchers.aw-watcher-lastfm = {
    package = inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.aw-watcher-lastfm;
    executable = "aw-watcher-lastfm";
  };

  xdg.configFile."activitywatch/aw-watcher-lastfm/config.yaml".text = ''
    username: kk-spartans
    apikey: ${config.sops.secrets."LASTFM_API_KEY".path}
    polling_interval: 10
  '';
}
