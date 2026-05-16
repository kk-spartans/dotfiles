{
  config,
  lib,
  pkgs,
  nvidia,
  ...
}:
{
  config = lib.mkMerge [
    {
      hardware.graphics.enable = true;

      services.xserver = {
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    }

    (lib.mkIf nvidia {
      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
      nixpkgs.config.cudaSupport = true;

      hardware.graphics.enable32Bit = true;

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;

        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      boot.initrd.kernelModules = [ "nvidia" ];

      environment.systemPackages = with pkgs.cudaPackages; [
        cudatoolkit
        cuda-samples
      ];
    })

    (lib.mkIf (!nvidia) {
      services.xserver.videoDrivers = [ "modesetting" ];

      boot.blacklistedKernelModules = [
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nouveau"
      ];

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{remove}="1"
      '';
    })
  ];
}
