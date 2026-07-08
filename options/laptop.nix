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

      environment.systemPackages = [
        config.boot.kernelPackages.turbostat
        pkgs.intel-gpu-tools
        pkgs.libva-utils
      ];

      # services.auto-cpufreq.enable = true;
      services.upower.enable = true;
      boot.kernelParams = [
  "resume=/dev/disk/by-label/swap"
  "pcie_aspm.policy=powersupersave"
];
      services.tlp = {
        enable = true;

        settings = {
          # CPU
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          # Intel HWP
          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;

          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 40;

          # Platform profile
          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          # PCIe
          PCIE_ASPM_ON_AC = "default";
          PCIE_ASPM_ON_BAT = "powersupersave";

          # Runtime power management
          RUNTIME_PM_ON_AC = "on";
          RUNTIME_PM_ON_BAT = "auto";

          # Wi-Fi
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "on";

          # Audio
          SOUND_POWER_SAVE_ON_AC = 0;
          SOUND_POWER_SAVE_ON_BAT = 1;

          # SATA
          SATA_LINKPWR_ON_AC = "med_power_with_dipm";
          SATA_LINKPWR_ON_BAT = "min_power";

          # USB autosuspend
          USB_AUTOSUSPEND = 1;
        };
      };
    })
  ];
}
