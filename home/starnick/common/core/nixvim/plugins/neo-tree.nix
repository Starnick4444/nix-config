{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>n"; # NOTE: used to be <leader>tt , might wanna change back
        action = ":Neotree action=focus reveal toggle<CR>";
        options.silent = true;
      }
    ];

    plugins.neo-tree = {
      enable = true;

      settings = {
        close_if_last_window = true;
        window = {
          width = 30;
          auto_expand_width = true;
        };
      };
    };
  };
}
