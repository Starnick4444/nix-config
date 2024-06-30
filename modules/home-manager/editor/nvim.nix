{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-autopairs
      fzf-vim
      vim-rooter
    ];

    extraConfig = builtins.readFile ./init.lua;
  };
  environment.variables.EDITOR = "nvim";
}
