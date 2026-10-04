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
      # The resolver container's fixed address on its own docker bridge. Fixed so
      # it does not move on recreate, because systemd-resolved is told about it.
      resolver = lib.mkOption {
        type = lib.types.str;
        default = "172.30.0.2";
        description = "Address of the dnsmasq container that serves the spartans zone.";
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