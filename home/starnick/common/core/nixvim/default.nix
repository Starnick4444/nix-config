{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./options.nix
    ./keymappings.nix
    ./autocommands.nix
    ./completion.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    # nixpkgs.pkgs = import inputs.nixpkgs-unstable {};
    # nixpkgs.useGlobalPackages = true;
    defaultEditor = true;

    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "hmts.nvim"
          "nvim-treesitter"
          "nvim-dap"
        ];
      };
      byteCompileLua.enable = true;
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    # https://github.com/neovim/neovim/issues/30985
    extraConfigLua = "
    for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
            if err ~= nil and err.code == -32802 then
                return
            end
            return default_diagnostic_handler(err, result, context, config)
        end
    end";
  };
  # environment.variables.EDITOR = "nvim";
}
