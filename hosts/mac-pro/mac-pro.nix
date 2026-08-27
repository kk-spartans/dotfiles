{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ../../modules/services/t3-server.nix
  ];

  home-manager.users.kk-spartans = {
    imports = [ inputs.nix-packages.homeManagerModules.wacli-sync ];
    services.wacli-sync.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.etc = {
    "asound.conf".text = ''
      pcm.!default {
        type plug
        slave.pcm "hw:0,0"
      }
      ctl.!default {
        type hw
        card 0
      }
    '';
    "alsa/alsa.conf".source = "${pkgs.alsa-lib}/share/alsa/alsa.conf";
  };

  environment.sessionVariables.ALSA_CONFIG_DIR = "/etc/alsa";
  environment.sessionVariables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  services.hardware.bolt.enable = true;

  boot.blacklistedKernelModules = [ "apple_gmux" ];

  # This host is an inference appliance. Keep the Ivy Bridge cores and both
  # Pitcairn cards out of their latency-oriented power-saving modes.
  systemd.services.local-inference-performance = {
    description = "Set persistent CPU/GPU inference performance policy";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ ! -w "$governor" ] || echo performance > "$governor"
      done
      for level in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        [ ! -w "$level" ] || echo high > "$level"
      done
    '';
  };

  systemd.services.obsidian-bisync = {
    description = "Bisync Obsidian vault to remote";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "kk-spartans";
      WorkingDirectory = "/home/kk-spartans/things/vault";
      ExecStart = "${pkgs.rclone}/bin/rclone bisync . obsidian:vault";
    };
  };

  systemd.timers.obsidian-bisync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
    };
  };

  users.users.kk-spartans.extraGroups = [ "audio" ];

  environment.systemPackages = [
    pkgs.libva-utils
    pkgs.vulkan-tools
  ];
}
