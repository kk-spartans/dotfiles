# How a machine resolves names, and how the spartans zone reaches it.
#
# The design, and why it is this way:
#
#   - systemd-resolved is the only resolver on the box; /etc/resolv.conf points
#     at its stub.
#   - Ordinary internet names go out the normal way, using whatever the link
#     provides. Nothing spartans-related sits in that path.
#   - Other machines get *.spartans from pihole on the gateway, and keep the
#     router and a public resolver behind it as fallbacks.
#
# What went wrong before, because it explains most of the choices here:
#
#   A systemd unit rewrote every NetworkManager connection to use pihole as the
#   only resolver, and pihole forwarded into unbound, which had no upstream
#   configured. So one misconfigured hop made *every* lookup on the machine fail,
#   and the damage was persisted into a dozen NetworkManager profiles. A DNS
#   outage took everything with it.
#
#   The gateway host cannot use pihole at all: pihole binds the wildcard on port
#   53 and systemd-resolved holds 127.0.0.53:53, and a wildcard bind and a
#   specific-address bind on one port cannot coexist. pihole only accepts a
#   listening mode of LOCAL/SINGLE/BIND/ALL/NONE -- never an interface name -- so
#   there is no way to make it bind just the tailnet. Rather than pick a loser,
#   the gateway resolves through resolved plus a small /etc/hosts list, which
#   also means pihole dying costs the tailnet its zone and costs the gateway
#   nothing.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  net = config.spartans.network;

  # The machine pihole runs on, which is the one that cannot use it.
  isGateway = config.networking.hostName == "mac-pro";

  # /etc/hosts entries, built as one flat list of lines.
  #
  # Bare device names plus their *.devices.spartans and t3code names. These go
  # on every host, not just the gateway: the gateway needs them because it cannot
  # ask pihole (see above), and on other machines a hosts entry that agrees with
  # the zone costs nothing.
  #
  # Written down once, in spartans.network.devices, rather than per host.
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

        # dnsmasq, inside pihole, re-reads addn-hosts on SIGHUP.
        $docker kill -s HUP pihole >/dev/null 2>&1 || true
      '';
    };
  };
}