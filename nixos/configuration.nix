#  This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    inputs.home-manager.nixosModules.home-manager

    ../modules/nixos/hyprland.nix
    ../modules/nixos/games.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import your home-manager configuration
      starnick = import ../home-manager/home.nix;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  # nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    # nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root//channels/nixos" ];
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # virtualization temp
  virtualisation.docker.enable = true;

  #tmp
  environment.etc."current-system-packages".text =

    let

      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;

      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);

      formatted = builtins.concatStringsSep "\n" sortedUnique;

    in

    formatted;
  # environment.etc =
  #   lib.mapAttrs'
  #   (name: value: {
  #     name = "nix/path/${name}";
  #    value.source = value.flake;
  #   })
  #   config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # it will get renamed to this in the future
  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

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
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Special config to load the latest (535 or 550) driver for the support of the 4070 SUPER
  };

  boot = {
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    extraModulePackages = with config.boot.kernelPackages; [ rtl88x2bu ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "ntfs" ];

    kernel.sysctl."vm.max_heap_count" = 1048576;
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    tmp.useTmpfs = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    # libraries = with pkgs; [
    #  xorg.libXau
    #  xorg.libXrandr
    #  xorg.libX11
    #  libGL
    #  krb5
    #  glib
    #  nss
    #  nspr
    #  xorg.libXcomposite
    #  xorg.libXdamage
    #  xorg.libXfixes
    #  xorg.libXtst
    #  freetype
    #  expat
    #  fontconfig.lib
    #  dbus.lib
    #  alsa-lib
    #  xorg.libXrender
    #  xorg.libXdmcp
    # 
    #  libsForQt5.qt5.qtbase
    #];
  };

  users.users = {
    starnick = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "wheel" "networkmanager" "audio" "docker" ];
    };
  };

  environment.systemPackages = with pkgs; [
    egl-wayland

    vim
    wget
    git
    home-manager
    wpa_supplicant
    kitty

    nix-init

    # dev
    git
    neovim
    gh
    unzip
    nixpkgs-fmt
    postman
    jetbrains.datagrip

    # reverse engineering
    godot_4

    openssl
    pkg-config
    # surrealdb
    # surrealist

    # sound and video
    pamixer
    brightnessctl
    playerctl

    small.dooit

    # file manager
    yazi

    # bluetooth
    bluez-tools
    blueberry

    # wm
  ];

  # Gtk config
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  fonts.packages = with pkgs; [
    nerdfonts
    fira-code
    noto-fonts-emoji
  ];

  # environment.shells = with pkgs; [ fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  /*
    programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
    };
  */

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = false;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
