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

  environment.systemPackages = [ t3-nightly ];

  home-manager.users.kk-spartans = {
    imports = [ inputs.nix-packages.homeManagerModules.default ];

    # operator is set by the tailscale-operator oneshot above; the upstream
    # module warns unconditionally when serve is enabled
    warnings = lib.mkForce [ ];

    services.t3-server = {
      enable = true;
      package = t3-nightly;
      tailscale.enable = true;
    };
  };
}
