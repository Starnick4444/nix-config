#  Starnick - Laptop
#  NixOS running on Laptop
#
###############################################################
{
  inputs,
  lib,
  pkgs,
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
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    {
      _module.args = {
        disk = "/dev/nvme0n1";
        withSwap = true;
        swapSize = 16;
      };
    }

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
      "hosts/common/optional/gaming.nix"
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/mpv.nix" # media player
      "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "laptop";
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

  # set custom autologin options. see greetd.nix for details
  autoLogin.enable = true;
  autoLogin.username = "starnick";
  #  autoLogin.username = config.hostSpec.username;
  #
  #  services.gnome.gnome-keyring.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  nix = {
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
    };
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

    initrd = {
      systemd.enable = true;
    };
  };

  #TODO(stylix): move this stuff to separate file but define theme itself per host
  # host-wide styling

  #hyprland border override example
  #  wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E});

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
