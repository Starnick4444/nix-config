{
  inputs,
  lib,
  ...
}:
{
  stylix = {
    targets = {
      hyprlock.enable = false;
      nixvim.enable = false;
    };
  };
}
