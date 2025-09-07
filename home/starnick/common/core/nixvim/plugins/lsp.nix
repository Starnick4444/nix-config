{
  programs.nixvim = {
    plugins = {
      lsp-format.enable = false;

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
            # settings.formatting.command = [ { __raw = "get_nix_formatter()"; } ];
          };
          dockerls.enable = true;
          csharp_ls.enable = true;
          eslint.enable = true;
          # fish_lsp.enable = true;
          html.enable = true;
          jsonls.enable = true;
          postgres_lsp.enable = true;
          buf_ls.enable = true;
          terraformls.enable = true;
          helm_ls.enable = true;
          # python type checker pyright.enable = true;
          # generic sql lsp sqls.enable = true;
        };
      };
    };
  };
}
