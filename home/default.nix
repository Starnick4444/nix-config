{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my-home;
in
{

  imports = [
    ./kitty
    ./fish
    # ./starship
    ./git
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

      packages = with pkgs; [
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
        comma
        obsidian

        # Office
        libreoffice-fresh

        # Media
        stremio
        mpv
        spotify
        obs-studio
        handbrake
        qbittorrent

        # social
        vesktop

        # probs nice to have's
        # nix-cleanup
        # ack
      ] ++ optionals cfg.includeFonts [
        # Fonts
        nerdfonts
        fira-code
        noto-fonts-emoji
      ] ++ optionals cfg.isWork [
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

        # benchmarking
        heaptrack
        samply

        # Network debugging
        wireshark

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
        # android-tools
        # autossh
      ];
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
