{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Basics
      vim-sensible
      # Add syntax/detection/indentation for langs
      vim-nix

      # To learn vim better
      # hardtime-nvim

      # File tree
      nvim-tree-lua
      nvim-web-devicons

      # Status line
      feline-nvim

      # Git info
      gitsigns-nvim

      # Indent lines
      # indent-blankline-nvim

      # Auto close
      nvim-autopairs

      # Fuzzy finder window
      telescope-nvim

      # Diagnostics window
      # trouble-nvim

      # Keybindings window
      legendary-nvim

      # Better native input/select windows
      dressing-nvim

      # Tabs
      bufferline-nvim

      # Peek line search
      numb-nvim

      # Fast navigation
      leap-nvim

      # Rainbow brackets
      # rainbow-delimiters-nvim # maybe

      # Notify window
      nvim-notify

      # Commenting
      comment-nvim

      # Syntax highlighting
      nvim-treesitter.withAllGrammars

      # Theme
      base16-nvim

      # Rust formatting
      rust-vim

      # LSP
      nvim-lspconfig
      # Mostly for linting
      none-ls-nvim
      # LSP status window
      fidget-nvim
      # Highlight selected symbol
      vim-illuminate # maybe

      # Completions
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      nvim-cmp
      lspkind-nvim

      # Debug adapter protocol
      nvim-dap
      telescope-dap-nvim
      nvim-dap-ui
      nvim-dap-virtual-text
    ];

    extraPackages = with pkgs; [
      tree-sitter
      # Language Servers
      # Bash
      nodePackages.bash-language-server
      # Haskell
      # stable.haskellPackages.haskell-language-server
      # Lua
      lua-language-server
      # Nix
      nil
      nixpkgs-fmt
      statix
      # Python
      # pyright
      # python-debug
      # black
      # Typescript
      # nodePackages.typescript-language-server
      # Web (ESLint, HTML, CSS, JSON)
      nodePackages.vscode-langservers-extracted
      # Telescope tools
      ripgrep
      fd
    ];

    extraConfig = ":luafile ~/.config/nvim/lua/init.lua";
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
  # environment.variables.EDITOR = "nvim";
}
