{ pkgs, ... }:
{
  # TODO add ttf-font-awesome or font-awesome for waybar
  fontProfiles = {
    enable = false;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
