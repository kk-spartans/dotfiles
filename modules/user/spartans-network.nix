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
      # Where the resolver lives. Two forms, because the gateway can reach its
      # own container on the docker bridge directly, while other machines have
      # to come in over the tailnet on the published port.
      resolver = lib.mkOption {
        type = lib.types.str;
        default = "172.30.0.2";
        description = ''
          The dnsmasq container that serves the spartans zone, as reachable from
          the gateway itself (its address on the spartans-dns bridge).
        '';
      };
      resolverTailnet = lib.mkOption {
        type = lib.types.str;
        default = "100.67.45.93:5300";
        description = ''
          The same resolver as reachable from other machines: the gateway's
          tailnet address and the published port. Port 53 cannot be published
          because systemd-resolved already holds 127.0.0.53:53 on that host.
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