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

    # MagicDNS is off for the tailnet. --accept-dns=false tells tailscaled to
    # leave this machine's DNS completely alone: no 100.100.100.100 resolver, no
    # *.ts.net search domain. The names in the spartans zone come from pihole
    # instead (see modules/user/networking.nix). The tailnet itself is
    # untouched, so this stays reversible per machine.
    # extraUpFlags only runs inside tailscaled-autoconnect, which is a
    # RemainAfterExit oneshot that already fired the first time this machine
    # joined — so flags set there are silently dropped on every later rebuild.
    # extraSetFlags runs `tailscale set` on each activation, which is what
    # actually sticks.
    extraSetFlags = [
      "--accept-routes"
      "--accept-dns=false"
    ];
  };
}
