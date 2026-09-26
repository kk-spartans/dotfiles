{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # The gateway machine. pihole runs there in the host network namespace, so
  # this is also where *.spartans names are published from.
  gateway = "100.67.45.93";
in
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # The t3code helper is a systemd *user* service that has to bind :443, and
  # ambient capabilities are not available to an unprivileged user manager. This
  # is the same knob container hosts set for the same reason.
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  # A DNS outage on the gateway must not stop `nixos-rebuild` reaching this
  # machine over ssh, and nix.buildMachines resolves these names. The spartans
  # zone is the source of truth for everything else.
  networking.extraHosts = ''
    ${gateway} mac-pro
    100.85.2.58 kk-spartans
  '';

  # tailscaled no longer installs a resolver (--accept-dns=false), so DNS is
  # this machine's own business. systemd-resolved handles it: the resolver is
  # pihole on the gateway, and "spartans" as a search domain keeps `ssh mac-pro`
  # and `dig immich.services` working the way the *.ts.net search domain used to.
  #
  # NetworkManager is deliberately not given these: its global dns= in
  # conf.d/[main] is a dns *mode* selector in NM 1.58, and its [connection]
  # form is silently ignored for already-active connections. resolved also
  # avoids the resolv.conf churn tailscaled was causing.
  services.resolved = {
    enable = true;
    fallbackDns = [ gateway ];
    # A plain search domain, not ~spartans: bare names should still work.
    settings.Resolve.Domains = [ "spartans" ];
  };

  # resolved owns /etc/resolv.conf; openresolv would fight it.
  networking.resolvconf.enable = false;

  # NetworkManager keeps handing the link the router's resolvers from DHCP, and
  # those win over the fallback. Its global dns= in conf.d is a dns *mode*
  # selector in NM 1.58 and its [connection] form is ignored, so say it
  # per connection instead and reapply in place — nothing has to reconnect.
  # spartans writes the generated zone into a directory bind-mounted into the
  # unbound container and asks for a reload over unbound-control, which wants a
  # client certificate and so usually fails. This is the fallback that actually
  # runs: notice the file changing and signal unbound, which re-reads its whole
  # configuration on SIGHUP.
  systemd.paths.spartans-dns-zone = {
    description = "Reload unbound when spartans rewrites the zone";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      # The directory, not the file: spartans writes the zone atomically
      # (temp file + rename), which shows up as a change to the directory and
      # not as a modify to the file, so watching the file never fires.
      PathChanged = "/home/kk-spartans/things/docker/edge/dns";
      Unit = "spartans-dns-zone-reload.service";
    };
  };

  systemd.services.spartans-dns-zone-reload = {
    description = "Ask unbound to re-read its configuration";
    serviceConfig = {
      Type = "oneshot";
      # No RemainAfterExit: a path unit will not re-trigger a service that is
      # still active, so the zone would only ever reload once.
      ExecStart = pkgs.writeShellScript "spartans-dns-zone-reload" ''
        # A unit's PATH is nearly empty; docker is not on it by default.
        docker=${pkgs.docker}/bin/docker

        # A bad zone makes unbound exit on SIGHUP, and a dead resolver takes the
        # whole tailnet's DNS with it, so check it came back and start it again
        # if it did not.
        $docker kill -s HUP unbound >/dev/null 2>&1 || true
        sleep 1
        if ! $docker inspect -f '{{.State.Running}}' unbound 2>/dev/null | grep -q true; then
          echo "unbound did not survive the reload, restarting it" >&2
          $docker start unbound >/dev/null
        fi
      '';
    };
  };

  systemd.services.resolvconf-to-pihole = {
    description = "Point NetworkManager connections at pihole instead of the router";
    wantedBy = [ "multi-user.target" ];
    after = [ "NetworkManager.service" ];
    wants = [ "NetworkManager.service" ];
    # Re-run if NM restarts and hands out the router's resolvers again.
    restartTriggers = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "resolvconf-to-pihole" ''
        gateway=${gateway}
        # Absolute paths: a systemd unit's PATH is almost empty, and awk
        # missing here silently produced zero connections.
        nmcli=${pkgs.networkmanager}/bin/nmcli
        awk=${pkgs.gawk}/bin/awk

        for uuid in $($nmcli -t -f UUID,TYPE connection show |
          $awk -F: '$2 ~ /^(802-3-ethernet|802-11-wireless|gsm|cdma)$/ { print $1 }'); do
          $nmcli connection modify "$uuid" \
            ipv4.ignore-auto-dns yes ipv4.dns "$gateway" \
            ipv6.ignore-auto-dns yes || true
        done

        # Reapply in place, so nothing has to reconnect and no lease is lost.
        # Only devices NM actually manages: reapplying an *externally* managed
        # one (tailscale0) makes NetworkManager flush the routes tailscaled put
        # there, and the tailnet quietly stops routing.
        for dev in $($nmcli -t -f DEVICE,STATE dev status |
          $awk -F: '$2 == "connected" && $1 != "lo" { print $1 }'); do
          $nmcli device reapply "$dev" || true
        done
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
