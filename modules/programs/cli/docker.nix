{
  config,
  pkgs,
  lib,
  inputs,
  nvidia,
  ...
}:

{
  
  config = lib.mkMerge [ {
virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  users.users.kk-spartans.extraGroups = [ "docker" ];
}
    (lib.mkIf nvidia {
      hardware.nvidia-container-toolkit.enable = true;
    })
  ];
}
