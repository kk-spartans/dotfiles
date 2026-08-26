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

  users.users.kk-spartans.extraGroups = [ "libvirtd" ];
}
