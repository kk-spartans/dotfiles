{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
    dumpcap.enable = true;
  };

  environment.systemPackages = [ pkgs.wireshark ]; # gui install
  users.users.kk-spartans.extraGroups = [ "wireshark" ];
}
