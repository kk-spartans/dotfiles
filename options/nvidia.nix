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
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
	  libva-vdpau-driver
          libvdpau-va-gl
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };

      home-manager.users.kk-spartans.home.packages = with pkgs; [
        mesa-demos
      ];

      services.xserver = {
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    }

    (lib.mkIf nvidia {
      boot.kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ];
      nixpkgs.config.cudaSupport = true;
      hardware.graphics.enable32Bit = true;
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;

        powerManagement = {
          enable = true;
          finegrained = true;
        };

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
        cuda_nvcc
        cuda_cudart
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
