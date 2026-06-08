{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/mmcblk0";
      imageSize = "64G";

      content = {
        type = "gpt";

        partitions = {
          boot = {
            size = "512M";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          root = {
            size = "100%";

            content = {
              type = "btrfs";

              subvolumes = {
                "@" = {
                  mountpoint = "/";
                };

                "@nix" = {
                  mountpoint = "/nix";
                };

                "@home" = {
                  mountpoint = "/home";
                };

                # for home-server stuff
                "@docker" = {
                  mountpoint = "/home/kk-spartans/docker";
                };
              };
            };
          };
        };
      };
    };
  };
}
