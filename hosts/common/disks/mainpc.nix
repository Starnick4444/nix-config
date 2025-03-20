# NOTE: ... is needed because dikso passes diskoFile
{ ... }:
{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = "/dev/nvme0n1"; # 2TB
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # override existing partition
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };

  environment.systemPackages = [
    # pkgs.yubikey-manager # For luks fido2 enrollment before full install
  ];
}
