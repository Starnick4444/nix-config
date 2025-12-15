{ pkgs, ... }:
{
  programs.rofi.enable = true;
  xdg.configFile.rofi = {
    source = ./config;
    recursive = true;
  };
}
