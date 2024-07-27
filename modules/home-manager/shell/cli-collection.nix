{ pkgs, ... }: {
  # Collection of useful CLI apps
  home.packages = with pkgs; [
    # Command Line
    timer
    bat
    eza
    fd
    btop
    tldr
    ripgrep
    rsync
    unzip
    tmux
    vim
    tree
    # dooit
    stremio
    # neovim
  ];
}
