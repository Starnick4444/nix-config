{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./treesitter.nix
    ./comment.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    # maybe tagbar
    ./telescope.nix
    ./rustaceanvim.nix
    ./dap.nix
  ];

  programs.nixvim = {
    colorschemes.gruvbox.enable = true;

    plugins = {
      gitsigns.enable = true;

      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      oil.enable = true;

      leap.enable = true;

      illuminate.enable = true;

      fidget.enable = true;

      dressing.enable = true;

      transparent.enable = true;

      # TODO: notify?

      # NOTE: gonna try it
      trim = {
        enable = true;
        settings = {
          ft_blocklist = [
            "checkhealth"
            "lspinfo"
            "neo-tree"
            "TelescopePrompt"
          ];
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      # Peek line search
      numb-nvim
    ];
    extraConfigLua = "require('numb').setup()";

    # TODO: move this to own module
    extraConfigLuaPre = let
      nixfmtPath = lib.getExe pkgs.nixfmt-rfc-style;
      alejandraPath = lib.getExe pkgs.alejandra;
    in ''
      local get_nix_formatter = function()
        local match = function(name)
          return string.find(
            vim.fn.getcwd() .. "/",
            "/" .. name .. "/"
          )
        end

        -- remove when nixpkgs will have formatted the code base
        if match("nixpkgs") then
          return ""
        end

        if match("nixpkgs") or match("nixvim") then
          return "${nixfmtPath}"
        end

        return "${alejandraPath}"
      end
    '';

    # Set indentation to 2 spaces
    files."after/ftplugin/nix.lua" = {
      localOpts = {
        tabstop = 2;
        shiftwidth = 2;
      };
    };
  };

  home.packages = with pkgs; [
    nixfmt-rfc-style
    alejandra
  ];
}
