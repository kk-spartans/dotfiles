# spartans: the internal gateway (github.com/kk-spartans/spartans).
#
# Three things live here:
#   1. the CLI, in globals, which is also the device helper
#   2. trust for the gateway's private root CA, plus the environment that makes
#      node/bun/curl actually use the system trust store on NixOS
#   3. the helper user service on a device that runs t3code
#
# The gateway itself runs as a container in ~/things/docker/edge; it needs
# nothing from this module.

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.spartans;
  spartansPkg = inputs.spartans.packages.${pkgs.stdenv.hostPlatform.system}.spartans;

  # The device name the gateway knows this host by.
  device = lib.head (lib.splitString "." config.networking.hostName);

  # Port t3code listens on. services.t3-server is a *home-manager* option
  # (see the nix-packages input), and only forced on hosts that import it,
  # which are exactly the hosts that enable the helper.
  t3Port = config.home-manager.users.kk-spartans.services.t3-server.port;

  # https://t3code.<device>.devices.spartans, served by the helper on a device
  # that runs t3code, or by the gateway itself on the gateway's machine.
  helper = {
    home.file.".t3/helper.yaml".text = ''
      # Written by nix; change the spartans.helper options instead.
      device: ${device}
      apex: spartans
      listen: "${cfg.helper.listen}"
      target: http://127.0.0.1:${toString t3Port}
      api: https://home.spartans
      cert_dir: /home/kk-spartans/.t3/tls
      state_dir: /home/kk-spartans/.t3
      renew_before: 720h
    '';

    systemd.user.services.spartans-helper = {
      Unit = {
        Description = "spartans t3code helper (t3code.${device}.devices.spartans)";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${spartansPkg}/bin/spartans helper";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
in
{
  options.spartans = {
    enable = lib.mkEnableOption "the spartans gateway client and CA trust";

    helper = {
      enable = lib.mkEnableOption "the t3code helper user service";
      listen = lib.mkOption {
        type = lib.types.str;
        default = ":443";
        description = "Bind address for the helper. 443 on any device that is not the gateway.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # ---------------------------------------------------------------- CA trust
    #
    # The gateway signs its own names: Caddy mints the leaves it serves and the
    # API signs one for each device helper, all from this root, whose key never
    # leaves the gateway.
    security.pki.certificateFiles = [ ./../../../certs/spartans-root.crt ];

    # NixOS puts the system store in /etc/ssl/certs/ca-bundle.crt, but binaries
    # built by nixpkgs are compiled against the *store* bundle instead, and
    # node/bun carry their own Mozilla list. Point everything at the system
    # bundle, which is a superset, or every curl, `bw sync` and agent tooling
    # call to a *.spartans name fails with an unknown authority.
    home-manager.users.kk-spartans = lib.mkMerge [
      {
        home.packages = [ spartansPkg ];
        home.sessionVariables = {
          NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
          SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
          CURL_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";
          NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-bundle.crt";
        };
      }
      (lib.mkIf cfg.helper.enable helper)
    ];
  };
}
