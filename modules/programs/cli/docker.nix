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
