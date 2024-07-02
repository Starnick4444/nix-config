{...}: {
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,filebrowser,window";
      "show-icons" = true;
      "display-drun" = " ";
      "display-run" = " ";
      "display-filebrowser" = " ";
      "display-window" = " ";
      "drun-display-format" = "{icon} {name}";
      "hover-select" = true;
      "me-select-entry" = "MouseSecondary";
      terminal = "kitty";
      "me-accept-entry" = "MousePrimary";
      "window-format" = "{w} · {c} · {t}";
      "icon-theme" = "Dracula";
      dpi = 1;
    };
    theme = ./theme.rasi;
  };
}
