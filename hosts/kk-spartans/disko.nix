{inputs, ...}: 
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";

      content = {
        type = "gpt";

        partitions = {
          esp = {
            size = "512M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          gap.size = "128G";

          swap = {
            size = "32G";
	    content.type = "swap";
	    label = "swap";
          };

          nixos = {
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

                "@snapshots" = {
                  mountpoint = "/.snapshots";
                };
              };
            };
          };
        };
      };
    };
  };
}
