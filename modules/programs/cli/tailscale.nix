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
# Two different things, and conflating them cost a lot of time:
#
#   MagicDNS is a tailnet-wide setting in the admin dashboard. It decides
#   whether *.ts.net names and the matching search domain exist. It is not
#   something a config file on this machine sets, and nothing here does.
#
#   --accept-dns is per-machine. It decides whether *this* node uses the DNS
#   configuration the tailnet publishes -- which here means the resolver at
#   100.100.100.100 forwarding to mac-pro:53. It is the switch that was wrong.
#
# In `tailscale debug prefs` the field called CorpDNS is this second one, not
# MagicDNS. Reading CorpDNS: false as "MagicDNS is off" is what made this look
# like a dashboard problem instead of a one-line config problem here.
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
