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
        # Containers cannot use the host's systemd-resolved stub at 127.0.0.53,
        # so dockerd needs real addresses. The spartans resolver answers the
        # zone; the public one is there for everything else.
        daemon.settings.dns = config.spartans.network.containerDNS;
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
