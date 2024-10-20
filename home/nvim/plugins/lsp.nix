{
  programs.nixvim = {
    plugins = {
      lsp-format.enable = true;

      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>cd" = "open_float";
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<leader>rn" = "rename";
            "<leader>fm" = "format";
            "<leader>ca" = "code_action";
          };
        };

        servers = {
          clangd.enable = true;
          texlab.enable = true;
          nil_ls = {
            enable = true;
            settings.formatting.command = [{__raw = "get_nix_formatter()";}];
          };
        };
      };
    };
  };
}
