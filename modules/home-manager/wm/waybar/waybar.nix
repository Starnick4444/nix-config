{
  config,
  pkgs,
  ...
}: {
  programs.waybar.enable = true;
  xdg.configFile.waybar = {
    source = ./config;
    recursive = true;
  };

  home.packages = with pkgs; [
    inotify-tools
    tomato-c
    networkmanagerapplet
  ];
  # home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./waybar;
}
