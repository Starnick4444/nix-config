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

      closeIfLastWindow = true;
      window = {
        width = 30;
        autoExpandWidth = true;
      };
    };
  };
}
