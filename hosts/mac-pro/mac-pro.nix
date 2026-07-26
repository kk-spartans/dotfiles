{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

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

  services.hardware.bolt.enable = true;

  boot.blacklistedKernelModules = [ "apple_gmux" ];

  users.users.kk-spartans.extraGroups = [ "audio" ];

  environment.systemPackages = [
    pkgs.libva-utils
    pkgs.vulkan-tools
  ];
}
