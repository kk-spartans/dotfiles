{
  config,
  pkgs,
  inputs,
  ...
}:
{
  networking.hostName = "kk-spartans";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
}
