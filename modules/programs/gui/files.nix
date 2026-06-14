{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.users.kk-spartans.home.packages = with pkgs; [
    libimobiledevice
    nautilus
    ifuse
  ];

  services.usbmuxd.enable = true;
}
