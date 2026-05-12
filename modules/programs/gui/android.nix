{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # android-studio-full // being honest to myself, i dont use this...
    # android-studio-tools
    # scrcpy
    android-tools
  ];

  nixpkgs.config.android_sdk.accept_license = true;
}
