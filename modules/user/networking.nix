# Host networking: NetworkManager, an open firewall (everything reachable here
# is already behind the tailnet), and unprivileged low ports so the device
# helper can bind :80/:443 as a user service.
#
# Name resolution is deliberately NOT configured here.
#
# Tailscale owns DNS on this tailnet. It hands its names to systemd-resolved
# through the tailscale0 link and pushes the tailnet-wide nameserver itself, so
# `mac-pro` and friends resolve with no configuration anywhere in this repo.
# An earlier version of this file did the opposite: it set Resolve.DNS to the
# gateway, wrote every tailnet device into networking.extraHosts, and hung a
# systemd path unit off the resolver's zone directory. All three were working
# around a resolver that was misconfigured at the time, and all three made the
# gateway a single point of failure for name resolution on every machine.
#
# The one thing worth knowing: the resolver that answers *.spartans is a
# container in ~/things/docker. It is not this module's business, and nothing
# here reloads it -- the gateway rewrites the zone and signals the resolver
# itself, from inside the container that writes it.
{
  config,
  lib,
  ...
}:

{
  networking.networkmanager.enable = true;

  # Everything reachable here is already behind the tailnet.
  networking.firewall.enable = false;

  # So the device helper can bind :443 and :80 as an unprivileged user service.
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  # systemd-resolved owns /etc/resolv.conf; openresolv would fight it.
  networking.resolvconf.enable = false;

  # Enabled, and configured not at all.
  #
  # Tailscale hands resolved the tailnet's names and the tailnet-wide nameserver
  # over the tailscale0 link, and NetworkManager hands it the link resolvers.
  # Setting Resolve.DNS here would override both by fiat, and that is how this
  # machine ended up unable to resolve anything when the gateway's resolver was
  # misconfigured: every lookup, including the ones for the machine's own
  # hostname and the ssh session used to fix it, went through one container.
  services.resolved.enable = true;
}
