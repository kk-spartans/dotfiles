{
  config,
  pkgs,
  ...
}:
{
  sops.secrets.TS_AUTHKEY = { };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-routes" ];
    authKeyFile = config.sops.secrets."TS_AUTHKEY".path;
  };
}
