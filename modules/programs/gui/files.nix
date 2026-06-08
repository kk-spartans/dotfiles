{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    libimobiledevice
    nautilus
    ifuse
    usbmuxd
  ];
}
