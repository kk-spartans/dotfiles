{
  config,
  pkgs,
  inputs,
  lib,
  laptop,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf laptop {
      powerManagement.enable = true;

      services.logind.settings.Login = {
        HandleLidSwitch = "lock";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "lock";
      };

      services.auto-cpufreq.enable = true;
      services.upower.enable = true;
    })
  ];
}
