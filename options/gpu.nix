{
  config,
  lib,
  pkgs,
  gpu,
  ...
}:
let
  validGpus = [
    "amd"
    "amd-si"
    "nvidia"
    "intel"
    "none"
  ];
  hasGpu = gpu != "none";
  isAmd = gpu == "amd" || gpu == "amd-si";
  isAmdSi = gpu == "amd-si";
  isModernAmd = gpu == "amd";
  isNvidia = gpu == "nvidia";
  isIntel = gpu == "intel";
in
{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = builtins.elem gpu validGpus;
          message = ''gpu must be one of: "amd", "amd-si", "nvidia", "intel", or "none"'';
        }
      ];
    }

    {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          libva-vdpau-driver
          libvdpau-va-gl
        ]
        ++ lib.optionals isModernAmd [
          rocmPackages.clr.icd
        ]
        ++ lib.optionals isIntel [
          intel-compute-runtime
          vpl-gpu-rt
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = if isAmd then "radeonsi" else "iHD";
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

    (lib.mkIf isNvidia {
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

    (lib.mkIf isAmd {
      services.xserver.videoDrivers = [ "amdgpu" ];
      boot.initrd.kernelModules = [ "amdgpu" ];
      hardware.graphics.enable32Bit = true;
    })

    (lib.mkIf isAmdSi {
      boot.kernelParams = [
        "radeon.si_support=0"
        "amdgpu.si_support=1"
      ];
    })

    (lib.mkIf isIntel {
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware.graphics.enable32Bit = true;
    })

    (lib.mkIf (!hasGpu) {
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
