{ lib, ... }:
{
  programs.starship = {
    enable = false;
    # settings = lib.importTOML ./starship.toml;
  };
}
