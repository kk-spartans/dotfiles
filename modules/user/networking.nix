# How a machine resolves names, and how the spartans zone reaches it.
#
# The design, and why it is this way:
#
#   - systemd-resolved is the only resolver on the box. /etc/resolv.conf points
#     at its stub.
#   - Ordinary internet names go out the normal way, using whatever the link
#     provides (the router, via DHCP). Nothing spartans-related sits in that path,
#     so a problem with the zone can never take the internet down with it.
#   - Only *.spartans is routed to the resolver container, via resolved's
#     per-domain routing. That is what `~apex` below does.
#
# The earlier version pointed resolved's *global* fallback at the gateway and had
# a systemd unit rewrite every NetworkManager connection to use it. That made
# pihole the resolver for everything, so when pihole's forwarding chain broke --
# which it did -- ordinary lookups stopped resolving too. The per-domain route is
# the whole fix: the blast radius of a broken zone is the zone.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  net = config.spartans.network;
  # On the gateway the container is reachable on the bridge; everywhere else it
  # is published on the tailnet.
  isGateway = config.networking.hostName == "mac-pro";
in
{
  networking.networkmanager.enable = true;

  # Everything reachable here is already behind the tailnet, and the helper and
  # the gateway both need to bind low ports without fighting a ruleset.
  networking.firewall.enable = false;

  # The device helper is a systemd *user* service that binds :443 and :80, and
  # ambient capabilities are not available to an unprivileged user manager. This
  # is the same knob container hosts set for the same reason.
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  # resolved handles DNS; openresolv would fight it for /etc/resolv.conf.
  networking.resolvconf.enable = false;


  services.resolved = {
    enable = true;

    # Prefer our resolver (it knows the spartans zone and forwards the rest),
    # but always keep real fallbacks behind it. This systemd (261) has no
    # per-domain routing -- DomainsRoute is not a recognised key -- so the zone
    # cannot be split off from the internet at the resolver. Putting the
    # fallbacks behind the container means a dead or broken container degrades
    # to "the internet still works, *.spartans does not", which is the failure
    # mode that is actually recoverable, rather than "nothing resolves".
    # The gateway reaches its own resolver on the bridge; a device uses the
    # published tailnet address instead, which is why this is a per-host value
    # rather than one constant.
    settings.Resolve.DNS = [
      (if isGateway then net.resolver else net.resolverTailnet)
    ];
    settings.Resolve.FallbackDNS = net.upstreamDNS;

    # A plain search domain, so a bare `ssh mac-pro` still works now that
    # MagicDNS is gone. Not ~spartans: bare names should keep working for things
    # that are not in the zone.
    settings.Resolve.Domains = [ net.apex ];
  };

  # A DNS outage on the gateway must not stop `nixos-rebuild` reaching this
  # machine over ssh, and nix.buildMachines resolves these names. The spartans
  # zone is the source of truth for everything else.
  networking.extraHosts = ''
    ${net.gateway} mac-pro
    ${net.laptop} kk-spartans
  '';

  # spartans writes the generated zone into a directory bind-mounted into the
  # resolver container and asks for a reload. This is the fallback that actually
  # runs: notice the file changing and signal dnsmasq, which re-reads its whole
  # configuration on SIGHUP.
  #
  # The gateway writes the zone with a temp file and a rename, which shows up as
  # a change to the *directory* and not a modify to the file, so the path unit
  # watches the directory. And the triggered service must not be RemainAfterExit,
  # or systemd will not re-trigger it and the zone only ever reloads once.
  systemd.paths.spartans-dns-zone = {
    description = "Reload the spartans resolver when the zone changes";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = "/home/kk-spartans/things/docker/edge/dns";
      Unit = "spartans-dns-zone-reload.service";
    };
  };

  systemd.services.spartans-dns-zone-reload = {
    description = "Ask the spartans resolver to re-read the zone";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "spartans-dns-zone-reload" ''
        # A unit's PATH is nearly empty; docker is not on it by default.
        docker=${pkgs.docker}/bin/docker

        # dnsmasq re-reads addn-hosts on SIGHUP.
        $docker kill -s HUP spartans-dns >/dev/null 2>&1 || true
      '';
    };
  };
}