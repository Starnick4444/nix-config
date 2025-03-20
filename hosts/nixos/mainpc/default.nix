#############################################################
#
#  Starnick - Main pc
#  NixOS running on Main pc
#
###############################################################
{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/mainpc.nix")

    #
    # ========== Misc Inputs ==========
    #
    inputs.stylix.nixosModules.stylix

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/greetd.nix" # display manager
      # "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/hyprland.nix" # window manager
      "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/obsidian.nix" # wiki
      "hosts/common/optional/plymouth.nix" # fancy boot screen
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/mpv.nix" # media player
      "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "mainpc";
    useYubikey = lib.mkForce false;
    domain = "";
    userFullName = "Nemes Bence";
    email = {
      user = "nemes.bence1@gmail.com";
    };
    networking = {
      ports = {
        tcp = {
          ssh = 22;
        };
        upd = { };
      };
    };
    hdr = lib.mkForce false;
    wifi = lib.mkForce true;
  };

  autoLogin.enable = true;
  autoLogin.username = "starnick";

  # set custom autologin options. see greetd.nix for details
  #  autoLogin.enable = true;
  #  autoLogin.username = config.hostSpec.username;
  #
  #  services.gnome.gnome-keyring.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  #  services.backup = {
  #    enable = true;
  #    borgBackupStartTime = "02:00:00";
  #    borgServer = "${config.hostSpec.networking.subnets.grove.hosts.oops.ip}";
  #    borgUser = "${config.hostSpec.username}";
  #    borgPort = "${builtins.toString config.hostSpec.networking.ports.tcp.oops}";
  #    borgBackupPath = "/var/services/homes/${config.hostSpec.username}/backups";
  #    borgNotifyFrom = "${config.hostSpec.email.notifier}";
  #    borgNotifyTo = "${config.hostSpec.email.backup}";
  #  };

  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  boot = {
    # nvidia gpu sleep, nvidia param for wayland
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia-drm.fbdev=1"
      "nvidia-drm.modeset=1"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = true;
        # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
        configurationLimit = lib.mkDefault 10;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    supportedFilesystems = [ "ntfs" ];

    initrd = {
      systemd.enable = true;
    };

    tmp.useTmpfs = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

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
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  zramSwap.enable = true;

  #hyprland border override example
  #  wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E});

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
