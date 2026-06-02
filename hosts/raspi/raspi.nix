{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:

let
  configTxt = pkgs.writeText "config.txt" ''
    [pi3]
    kernel=u-boot-rpi3.bin
    core_freq=250

    [pi02]
    kernel=u-boot-rpi3.bin

    [pi4]
    kernel=u-boot-rpi4.bin
    enable_gic=1
    armstub=armstub8-gic.bin
    disable_overscan=1
    arm_boost=1

    [cm4]
    otg_mode=1

    [all]
    arm_64bit=1
    enable_uart=1
    avoid_warnings=1
  '';
in
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=ttyAMA0,115200n8"
    "console=tty0"
  ];

  boot.consoleLogLevel = 7;

  system.activationScripts.raspberrypi-firmware = ''
    if [ ! -f /boot/bootcode.bin ]; then
      echo "populating /boot with Raspberry Pi firmware..."
      cp -r "${pkgs.raspberrypifw}/share/raspberrypi/boot/"* /boot/
      cp "${pkgs.ubootRaspberryPi3_64bit}/u-boot.bin" /boot/u-boot-rpi3.bin
      cp "${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin" /boot/u-boot-rpi4.bin
      cp "${pkgs.raspberrypi-armstubs}/armstub8-gic.bin" /boot/armstub8-gic.bin
      cp ${configTxt} /boot/config.txt
      sync
    fi
  '';
  disko.imageBuilder = {
    enableBinfmt = true;
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    kernelPackages = inputs.nixpkgs.legacyPackages.x86_64-linux.linuxPackages_latest;
  };
}
