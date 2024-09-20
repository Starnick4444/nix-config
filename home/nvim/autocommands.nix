{
  programs.nixvim.autoCmd = [
    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex" # inria
        "latex" # inria
        "markdown"
      ];
      command = "setlocal spell spelllang=en";
    }
  ];
}
