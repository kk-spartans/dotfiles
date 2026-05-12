{
  config,
  pkgs,
  lib,
  inputs,
  nvidia,
  ...
}:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  }
  // lib.optionalAttrs nvidia {
    enableNvidia = true;
  };

  users.users.kk-spartans.extraGroups = [ "docker" ];
}
