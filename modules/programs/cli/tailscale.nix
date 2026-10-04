# Tailscale, and who owns name resolution.
#
# The division of labour, which is the whole point and was previously backwards:
#
#   Tailscale owns DNS on this tailnet. tailscaled runs a resolver at
#   100.100.100.100, hands it to systemd-resolved on the tailscale0 link, and
#   answers the tailnet's own names itself. Everything else it forwards to the
#   nameserver the tailnet is configured with -- which is mac-pro:53, where the
#   spartans zone lives.
#
#   So a lookup of home.spartans goes: resolved -> tailscale0 -> 100.100.100.100
#   -> mac-pro:53. And a lookup of kk-spartans is answered by Tailscale without
#   leaving the machine. Neither needs anything configured in Nix.
#
# MagicDNS is off, so there is no *.ts.net search domain -- the names in this
# setup are the short ones from the spartans zone, and a search domain would
# only make them ambiguous. Note that MagicDNS being off does NOT disable the
# resolver: it is a separate switch from --accept-dns.
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

    # extraUpFlags only runs inside tailscaled-autoconnect, which is a
    # RemainAfterExit oneshot that already fired the first time this machine
    # joined -- so flags set there are silently dropped on every later rebuild.
    # extraSetFlags runs `tailscale set` on each activation, which is what
    # actually sticks.
    #
    # --accept-dns is deliberately NOT set to false. It was, and that is why
    # nothing resolved over the tailnet: tailscaled was told to leave DNS alone,
    # tailscale0 got no resolver, and every *.spartans lookup on every machine
    # was being answered by whatever systemd-resolved happened to be configured
    # with in Nix. Turning it off was an attempt to stop Tailscale interfering
    # with a resolver that was, at the time, misconfigured -- and it meant the
    # tailnet silently had no DNS path at all instead.
    extraSetFlags = [ "--accept-routes" ];

    # tailscaled applies its DNS config to systemd-resolved over the bus. If
    # resolved restarts underneath it, tailscaled does not always notice and
    # re-apply, and tailscale0 is left with no resolver -- the state this machine
    # was in for hours, with no error anywhere to say so. Ordering the unit
    # after resolved makes that ordering deterministic on boot.
  };

  systemd.services.tailscaled = {
    after = [ "systemd-resolved.service" ];
    wants = [ "systemd-resolved.service" ];
  };
}