{
  config,
  pkgs,
  lib,
  inputs,
  gpu,
  ...
}:

{

  config = lib.mkMerge [
    {
      virtualisation.docker = {
        # No custom DNS. Dockerd runs an embedded resolver at 127.0.0.11 inside
        # every container's network namespace: it answers container names
        # itself and forwards everything else to the host's resolv.conf, which
        # Tailscale maintains. Handing it a fixed list instead meant every
        # container resolved through one hardcoded resolver address, and a
        # change to the tailnet's DNS silently broke all of them.
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };

      users.users.kk-spartans.extraGroups = [ "docker" ];
    }
    (lib.mkIf (gpu == "nvidia") {
      hardware.nvidia-container-toolkit.enable = true;
    })
  ];
}
