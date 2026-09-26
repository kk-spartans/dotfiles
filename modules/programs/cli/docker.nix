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
        # The host resolves through systemd-resolved on 127.0.0.53, which
        # dockerd cannot use as an upstream for containers. Point them at pihole
        # on the tailnet address instead: it answers for the spartans zone and
        # forwards everything else.
        daemon.settings.dns = [ "100.67.45.93" "1.1.1.1" ];
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
