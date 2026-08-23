{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  t3code = pkgs.t3code.override {
    enableCodex = true;
    enableOpencode = true;
  };
in
{
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
