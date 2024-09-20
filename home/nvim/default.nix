_: {
  imports = [
    ./options.nix
    ./keymappings.nix
    ./autocommands.nix
    ./completion.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "hmts.nvim"
          "nvim-treesitter"
        ];
      };
      byteCompileLua.enable = true;
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };
  # environment.variables.EDITOR = "nvim";
}
