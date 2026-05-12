{
  config,
  pkgs,
  ...
}:
{
  sops.secrets.TS_AUTHKEY = { };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."TS_AUTHKEY".path;
  };
}
