{
  config,
  pkgs,
  inputs,
  ...
}:
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
