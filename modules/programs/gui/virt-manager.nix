{
  config,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # TPM for Win11 VMs (OVMF now bundled with qemu by default)
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  users.users.kk-spartans.extraGroups = [ "libvirtd" ];
}
