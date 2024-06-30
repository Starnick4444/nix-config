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

    extraConfig = ":luafile ~/.config/nvim/lua/init.lua";
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
  # environment.variables.EDITOR = "nvim";
}
