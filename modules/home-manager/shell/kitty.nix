{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "SauceCodePro Nerd Font Mono";
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 12;
      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      # term = "xterm-256color";
      scrollback_lines = 100000;
      window_padding_width = 4;

      # foreground = "#D8DEE9";
      # background = "#2E3440";
      # selection_foreground = "#000000";
      # selection_background = "#FFFACD";
      # url_color = "#0087BD";
      # cursor = "#81A1C1";

      base0 = "131213";
      base1 = "2f1823";
      base2 = "472234";
      base3 = "ffbee3";
      base4 = "9b2a46";
      base5 = "f15c99";
      base6 = "81506a";
      base7 = "632227";
      base8 = "b00b69";
      base9 = "ff9153";
      base10 = "ffcc00";
      base11 = "9ddf69";
      base12 = "714ca6";
      base13 = "008080";
      base14 = "a24030";
      base15 = "a24030";
    };
  };
}
