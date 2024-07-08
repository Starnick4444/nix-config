{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    catppuccin-cursors
    catppuccin-gtk
  ];
  home.pointerCursor = {
    name = "catppuccin-mocha-blue-cursors";
    package = pkgs.catppuccin-cursors.mochaBlue;
    size = 24;
  };
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin";
      package = pkgs.catppuccin-gtk;
    };
    cursorTheme = {
      name = "catppuccin-mocha-blue-cursors";
      package = pkgs.catppuccin-cursors.mochaBlue;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
    font = {
      name = "FiraCode Nerd Font";
      size = 10;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
