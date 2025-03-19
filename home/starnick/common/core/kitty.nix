{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;

    settings = {
      scrollback_lines = 10000;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      #      "ctrl+v" = "paste_from_clipboard"; #interferes with visual block mode in vim
    };
  };
}
