{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.my-linux;
in {
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
    # kernelPackages = pkgs.linuxPackages_cachyos;

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

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  powerManagement.powertop.enable = true;

  my-linux = {
    enableNixOptimise = true;
    includeGames = false;
  };

  zramSwap.enable = true;
}
