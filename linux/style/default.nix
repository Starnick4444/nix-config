{pkgs, ...}: let
  opacity = 0.7;
  fontSize = 12;
in {
  stylix = {
    enable = true;
    image = ../../home/wm/hyprland/wallpaper_11.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    opacity = {
      terminal = opacity;
      popups = opacity;
    };

    cursor = {
      package = pkgs.catppuccin-cursors.mochaBlue;
      name = "catppuccin-mocha-blue-cursors";
      size = 24;
    };

    fonts = {
      /*
      serif = {
        package = aleo-fonts;
        name = "Aleo";
      };

      */
      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK JP";
      };

      monospace = {
        package = pkgs.nerd-fonts.sauce-code-pro;
        name = "SauceCodePro Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = fontSize;
        desktop = fontSize;
        popups = fontSize;
        terminal = fontSize;
      };
    };

    targets.nixvim.enable = false;

    /*
    targets.nixvim = {
      enable = false;
      plugin = "base16-nvim";
      transparentBackground.signColumn = true;
    };
    */
  };
}
