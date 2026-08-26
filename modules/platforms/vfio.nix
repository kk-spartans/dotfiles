{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.vfio = {
    enable = lib.mkEnableOption "NVIDIA VFIO passthrough for Hybrid BIOS (Intel host + T1200 guest)";
    gpuIds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "10de:1fbc" # T1200 Laptop GPU
        "10de:10fa" # T1200 Audio
      ];
      description = "PCI IDs to bind to vfio-pci at boot";
    };
  };

  config = lib.mkIf config.my.vfio.enable {
    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=${lib.concatStringsSep "," config.my.vfio.gpuIds}"
    ];

    boot.initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
    ];
    boot.kernelModules = [ "vfio_pci" ];

    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nouveau"
    ];

    # Host uses Intel iGPU when vfio is on — requires BIOS Hybrid mode (Discrete disables 00:02.0)
    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
    hardware.nvidia.modesetting.enable = lib.mkForce false;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # TPM for Win11 passthrough VMs (OVMF is now included by default in qemu)
    virtualisation.libvirtd.qemu.swtpm.enable = true;
  };
}
