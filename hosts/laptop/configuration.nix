{ pkgs
, config
, lib
, ...
}:
with lib;
let
  cfg = config.my-linux;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../linux
  ];

  boot = {
    initrd.systemd.enable = true;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # supportedFilesystems = [ "ntfs" ];

    kernel.sysctl."vm.max_heap_count" = 1048576;
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # tmp.useTmpfs = true;
  };

  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Budapest";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  my-linux = {
    enableNixOptimise = true;
    includeGames = false;
  };

  zramSwap.enable = true;
}
