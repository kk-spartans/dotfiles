{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 2097152;
    "fs.inotify.max_user_instances" = 4096;
    "fs.inotify.max_queued_events" = 65536;
  };

  # Allow building aarch64 images (like Raspberry Pi) from x86_64
  boot.binfmt.emulatedSystems = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    "aarch64-linux"
  ];
}
