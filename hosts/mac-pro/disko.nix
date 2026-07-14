{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      imageSize = "1T";

      content = {
        type = "gpt";

        partitions = {
          boot = {
            size = "512M";
            type = "EF00";

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
              };
            };
          };
        };
      };
    };
  };
}
