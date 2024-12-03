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
    # nvidia gpu sleep, nvidia param for wayland
    kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia-drm.fbdev=1" "nvidia-drm.modeset=1"];

    # wifi drivers
    extraModulePackages = with config.boot.kernelPackages; [rtl88x2bu];

    initrd.systemd.enable = true;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = ["ntfs"];

    kernel.sysctl."vm.max_heap_count" = 1048576;
    # use latest kernel
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_cachyos;

    tmp.useTmpfs = true;
  };

  networking = {
    hostName = "mainpc";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Budapest";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  };

  services.ratbagd.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    # modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # fix for https://github.com/NixOS/nixpkgs/issues/357643
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  my-linux = {
    enableNixOptimise = true;
    includeGames = true;
  };

  virtualisation.docker.enable = true;

  zramSwap.enable = true;
}
