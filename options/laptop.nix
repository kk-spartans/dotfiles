{
  config,
  pkgs,
  inputs,
  lib,
  laptop,
  ...
}:
let
  cfg = config.my.laptop;
in
{
  options.my.laptop.tlp.useBatterySettingsOnAc = lib.mkEnableOption "battery TLP limits while plugged in";

  config = lib.mkMerge [
    (lib.mkIf laptop {
      my.laptop.tlp.useBatterySettingsOnAc = lib.mkDefault false;

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
          CPU_SCALING_GOVERNOR_ON_AC =
            if cfg.tlp.useBatterySettingsOnAc then "powersave" else "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC =
            if cfg.tlp.useBatterySettingsOnAc then "power" else "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_BOOST_ON_AC = if cfg.tlp.useBatterySettingsOnAc then 0 else 1;
          CPU_BOOST_ON_BAT = 0;

          # Intel HWP
          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = if cfg.tlp.useBatterySettingsOnAc then 40 else 100;

          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 40;

          # Platform profile
          PLATFORM_PROFILE_ON_AC =
            if cfg.tlp.useBatterySettingsOnAc then "low-power" else "performance";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          # PCIe
          PCIE_ASPM_ON_AC =
            if cfg.tlp.useBatterySettingsOnAc then "powersupersave" else "default";
          PCIE_ASPM_ON_BAT = "powersupersave";

          # Runtime power management
          RUNTIME_PM_ON_AC = if cfg.tlp.useBatterySettingsOnAc then "auto" else "on";
          RUNTIME_PM_ON_BAT = "auto";

          # Wi-Fi
          WIFI_PWR_ON_AC = if cfg.tlp.useBatterySettingsOnAc then "on" else "off";
          WIFI_PWR_ON_BAT = "on";

          # Audio
          SOUND_POWER_SAVE_ON_AC = if cfg.tlp.useBatterySettingsOnAc then 1 else 0;
          SOUND_POWER_SAVE_ON_BAT = 1;

          # SATA
          SATA_LINKPWR_ON_AC =
            if cfg.tlp.useBatterySettingsOnAc then "min_power" else "med_power_with_dipm";
          SATA_LINKPWR_ON_BAT = "min_power";

          # USB autosuspend
          USB_AUTOSUSPEND = 1;

          # Battery charging
          START_CHARGE_THRESH_BAT0 = 96;
          STOP_CHARGE_THRESH_BAT0 = 100;
        };
      };
    })
  ];
}
