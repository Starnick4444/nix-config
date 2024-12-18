{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.my-home;
in {
  imports = [
    ./kitty
    ./fish
    # ./starship
    ./git
    ./ssh
    ./nvim
    ./btop
    ./fd
    ./direnv
    ./wm
    ./nyaa
    ./firefox
    # ./games # moved to nixos modules
  ];

  options.my-home = {
    includeFonts = lib.mkEnableOption "fonts";
    useNeovim = lib.mkEnableOption "neovim";
    isWork = lib.mkEnableOption "work profile";
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "less";
      };

      packages = with pkgs;
        [
          # command line utilities
          timer
          bat
          eza
          fd
          btop
          tldr
          ripgrep
          rsync
          unzip
          tree
          dust
          fastfetch
          dooit
          git
          kitty
          yazi
          obsidian
          zoxide

          # Office
          libreoffice-fresh

          # Media
          stremio
          mpv
          spotify
          obs-studio
          handbrake
          qbittorrent
          krita

          # social
          vesktop

          # probs nice to have's
          # nix-cleanup
          # ack
          # hardware-config
          piper
        ]
        ++ optionals cfg.includeFonts [
          # Fonts
          nerd-fonts.sauce-code-pro
          fira-code
          noto-fonts-emoji
        ]
        ++ optionals cfg.isWork [
          # dev
          nixpkgs-fmt
          postman
          jetbrains.datagrip
          nix-init
          sqlx-cli
          (fenix.complete.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ])
          rust-analyzer
          gcc
          loc
          android-studio
          # android-studio-tools
          android-tools
          scrcpy
          jadx
          frida-tools
          (pkgs.callPackage ./objection/default.nix {})

          # benchmarking
          heaptrack
          samply

          # Network debugging
          wireshark
          burpsuite

          # Cross compilation
          cargo-cross

          # Work packages 2
          # postgresql
          # awscli2
          # oktoast
          # toast-services
          # pizzabox
          # heroku
          # colima
          # docker
          # docker-compose
          # docker-credential-helpers
          # autossh
        ];
    };

    stylix = {
      targets = {
        hyprlock.enable = false;
        nixvim.enable = false;
      };
    };

    fonts.fontconfig.enable = cfg.includeFonts;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # programs.nix-index.enable = true;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";
  };
}
