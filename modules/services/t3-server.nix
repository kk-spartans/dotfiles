{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Single closure shared by the user service and the interactive `t3` CLI.
  t3code = pkgs.t3code.override {
    enableClaude = true;
    enableOpencode = true;
  };
in
{
  # t3-server runs as a user unit and needs to call `tailscale serve`;
  # keep the operator assignment declarative in case tailscale state resets.
  systemd.services.tailscale-operator = {
    description = "Set tailscale operator for the t3-server user service";
    wantedBy = [ "multi-user.target" ];
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.tailscale}/bin/tailscale set --operator kk-spartans";
      RemainAfterExit = true;
    };
  };

  # Let the t3-server user manager (and its services) run without login.
  users.users.kk-spartans.linger = true;

  environment.systemPackages = [ t3code ];

  home-manager.users.kk-spartans = {
    imports = [ inputs.nix-packages.homeManagerModules.default ];

    services.t3-server = {
      enable = true;
      package = t3code;
      tailscale.enable = true;
    };
  };
}
