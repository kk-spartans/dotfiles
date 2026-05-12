{
  config,
  pkgs,
  inputs,
  ...
}:
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
}
