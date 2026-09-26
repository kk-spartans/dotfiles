{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  t3-nightly = pkgs.t3-nightly.override {
    enableCodex = true;
    enableOpencode = true;
  };
in
{
  users.users.kk-spartans.linger = true;

  environment.systemPackages = [ t3-nightly ];

  home-manager.users.kk-spartans = {
    imports = [ inputs.nix-packages.homeManagerModules.default ];

    services.t3-server = {
      enable = true;
      package = t3-nightly;
      tailscale.enable = true;
      # t3 binds the tailnet address directly and the spartans gateway
      # terminates TLS for it: t3code.<host>.devices.spartans. Using
      # `tailscale serve` instead would make tailscaled own port 443 on the
      # host, which is where the gateway needs to bind.
      tailscale.bindIp = true;
      tailscale.serve = false;
    };
  };
}
