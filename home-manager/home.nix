# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # outputs.homeManagerModules.git
    # outputs.homeManagerModules.sh
    # outputs.homeManagerModules.cli-collection
    # outputs.homeManagerModules.virtualization
    # outputs.homeManagerModules.firefox

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    ../modules/home-manager/git/git.nix # My git config
    ../modules/home-manager/shell/sh.nix # My zsh config
    ../modules/home-manager/shell/cli-collection.nix # Usefull cli apps
    ../modules/home-manager/wm/hyprland.nix # Hyprland config
    # ../modules/home-manager/virtualization/virtualization.nix # Virtual machines
    # ../modules/home-manager/browser/firefox.nix # Browser config

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "starnick";
    homeDirectory = "/home/starnick";

  packages = (with pkgs; [
    # Core
    zsh
    alacritty
    firefox # consider librewolf
    dmenu
    rofi
    git

    # Office
    libreoffice-fresh
    gnome.nautilus
    gnome.gnome-calendar
    gnome.gnome-maps

    wine

    spotify
    vlc
    obs-studio
    ffmpeg
    mediainfo
    libmediainfo
  ]);
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "/home/starnick/Media/Music";
    videos = "/home/starnick/Media/Videos";
    pictures = "/home/starnick/Media/Pictures";
    download = "/home/starnick/Download";
    documents = "/home/starnick/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "/home/starnick/.dotfiles";
      XDG_ARCHIVE_DIR = "/home/starnick/Archive";
      XDG_VM_DIR = "/home/starnick/Machines";
      XDG_GAME_DIR = "/home/starnick/Media/Games";
      XDG_GAME_SAVE_DIR = "/home/starnick/Media/Game Saves";
    };
    # mime.enable = true; #TODO whats this
    # mimeApps.enable = true;
  };

  # Add stuff for your user as you see fit:
  # TODO move to own file
  programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
