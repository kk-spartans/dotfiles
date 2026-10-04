# How a machine resolves names, and how the spartans zone reaches it.
#
# The design:
#
#   - The gateway serves :53 for the whole tailnet and forwards to pihole. Every
#     machine points systemd-resolved at the gateway's address, so nothing here
#     has to know or care where pihole actually runs.
#   - The gateway always keeps real fallbacks behind pihole, so if pihole or the
#     gateway is down, ordinary internet lookups still resolve and only the zone
#     goes away.
#   - Device names are in /etc/hosts as well, because a DNS outage on the gateway
#     must not stop `nixos-rebuild` reaching this machine over ssh, and because
#     nix.buildMachines resolves them.
#
# What went wrong before, because it explains the shape:
#
#   A systemd unit rewrote every NetworkManager connection to use pihole as the
#   only resolver, and persisted that into a dozen connection profiles. It also
#   pointed unbound at port 5353, which systemd-resolved owns, and gave unbound no
#   forward-addr at all. So one misconfigured hop made every lookup on the machine
#   fail, and the damage outlived the fix. There is no unit like that any more,
#   and no address is written here except in spartans.network.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  net = config.spartans.network;

  # Device names, in /etc/hosts. Written down once, in spartans.network.devices,
  # so they survive a resolver outage and there is one place to change an address.
  hostEntries = lib.concatStringsSep "\n" (
    lib.flatten (lib.mapAttrsToList (name: addr: [
      "${addr} ${name}"
      "${addr} ${name}.devices.${net.apex}"
      "${addr} t3code.${name}.devices.${net.apex}"
    ]) net.devices)
    ++ [
      "${net.gateway} home.${net.apex}"
      "${net.gateway} ${net.apex}"
    ]
  );
in
{
  networking.networkmanager.enable = true;

  # Everything reachable here is already behind the tailnet, and the device
  # helper needs to bind :443 and :80 as an unprivileged user service.
  networking.firewall.enable = false;
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  # resolved owns /etc/resolv.conf; openresolv would fight it.
  networking.resolvconf.enable = false;

  services.resolved = {
    enable = true;

    # The gateway, which serves :53 for the tailnet and forwards to pihole.
    settings.Resolve.DNS = [ net.gateway ];

    # Real resolvers behind it, so a problem with the zone cannot stop the
    # machine resolving anything else. This systemd (261) has no per-domain
    # routing -- DomainsRoute is not a key it recognises -- so the zone cannot be
    # split off from the internet at the resolver; the fallbacks are the best
    # available answer to that.
    settings.Resolve.FallbackDNS = net.upstreamDNS;

    # A plain search domain, so a bare `ssh mac-pro` still works now that
    # MagicDNS is gone.
    settings.Resolve.Domains = [ net.apex ];
  };

  networking.extraHosts = hostEntries;

  # The gateway rewrites the zone atomically (temp file + rename), which shows up
  # as a change to the *directory* rather than a modify to the file, so the path
  # unit watches the directory. The triggered service must not be
  # RemainAfterExit, or systemd will not re-trigger it and the zone only ever
  # reloads once.
  systemd.paths.spartans-dns-zone = {
    description = "Reload the spartans resolver when the zone changes";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = "/home/kk-spartans/things/docker/edge/dns";
      Unit = "spartans-dns-zone-reload.service";
    };
  };

  systemd.services.spartans-dns-zone-reload = {
    description = "Ask pihole to re-read the generated zone";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "spartans-dns-zone-reload" ''
        # A unit's PATH is nearly empty; docker is not on it by default.
        docker=${pkgs.docker}/bin/docker

        # Signal dnsmasq inside pihole, not the container: `docker kill -s HUP
        # pihole` signals the container's init, and pihole's supervisor treats
        # SIGHUP as a request to shut down cleanly -- so reloading the zone was
        # killing the resolver, which is why it kept going missing.
        $docker exec pihole pkill -SIGHUP dnsmasq >/dev/null 2>&1 || true
      '';
    };
  };
}