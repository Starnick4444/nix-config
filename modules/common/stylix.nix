{
  lib,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = lib.custom.relativeToRoot "assets/wallpapers/zen-01.png";
    #      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";

    opacity = {
      terminal = 0.8;
      popups = 0.8;
    };

    cursor = {
      package = pkgs.catppuccin-cursors.mochaBlue;
      name = "catppuccin-mocha-blue-cursors";
      size = 24;
    };
    polarity = "dark";

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
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes =
        let
          fontSize = 12;
        in
        {
          applications = fontSize;
          desktop = fontSize;
          popups = fontSize;
          terminal = fontSize;
        };
    };
    # program specific exclusions
    targets = {
      nixvim.enable = false;
    };
  };

  home-manager.sharedModules = [
    {
      stylix.enable = true;
    }
  ];
}
