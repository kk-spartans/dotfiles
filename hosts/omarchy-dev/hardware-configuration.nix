{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoFormat = true;
  };

  # nixos-rebuild build-vm sizing.
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 6144;
      diskSize = 24576;
    };
  };

  # No NVIDIA passthrough: the omarchy-dev VM exercises the shell/session
  # plumbing on virtio-gpu.
}
