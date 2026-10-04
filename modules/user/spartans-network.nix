# Facts about the spartans network that more than one module needs.
#
# These used to be scattered as bare IP literals through modules/user/networking.nix
# and modules/programs/cli/docker.nix, which meant changing a tailnet address meant
# hunting for strings. They live here, once, and the modules read these options.
{ lib, ... }:
{
  options.spartans = {
    network = {
      gateway = lib.mkOption {
        type = lib.types.str;
        default = "100.67.45.93";
        description = ''
          Tailnet address of the gateway host (mac-pro). It runs the resolver
          and publishes the *.spartans zone, so this is where every other machine
          sends *.spartans lookups.
        '';
      };
      laptop = lib.mkOption {
        type = lib.types.str;
        default = "100.85.2.58";
        description = "Tailnet address of the laptop (kk-spartans).";
      };
      # Every tailnet device, so the gateway can resolve their names without the
      # resolver it cannot run. Devices are few and their addresses are stable;
      # this is the one place they are written down.
      devices = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          mac-pro = "100.67.45.93";
          kk-spartans = "100.85.2.58";
          phone = "100.72.2.118";
          tablet = "100.83.60.58";
        };
        description = "Tailnet address of each device, by name.";
      };
      # Where the resolver lives. Two forms, because the gateway can reach its
      # own container on the docker bridge directly, while other machines have
      # to come in over the tailnet on the published port.
      resolver = lib.mkOption {
        type = lib.types.str;
        default = "100.67.45.93";
        description = ''
          The resolver that serves *.spartans, on its port 53 -- reachable from
          other machines on the tailnet.

          The gateway host deliberately does not use this for itself: pihole
          binds the wildcard on port 53, and systemd-resolved already holds
          127.0.0.53:53, and those cannot coexist. So the gateway resolves
          through resolved and /etc/hosts, which also means pihole dying costs
          the tailnet its zone and costs the gateway nothing at all.
        '';
      };
      # Where ordinary (non-spartans) lookups go. The router first so
      # tailnet-internal names resolve, a public resolver as a fallback. Nothing
      # spartans-related is in this path, so a broken zone cannot take the
      # internet down.
      upstreamDNS = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "192.168.29.1" "1.1.1.1" ];
        description = "Resolvers for names outside the spartans zone.";
      };
      apex = lib.mkOption {
        type = lib.types.str;
        default = "spartans";
        description = "The internal DNS zone everything is published under.";
      };
      # Where the docker DNS server settings point containers. Containers cannot
      # use the host's systemd-resolved stub at 127.0.0.53, so they get the
      # resolver directly plus a public fallback for anything outside the zone.
      containerDNS = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "172.30.0.2" "1.1.1.1" ];
        description = "Resolvers handed to docker containers.";
      };
    };
  };
}