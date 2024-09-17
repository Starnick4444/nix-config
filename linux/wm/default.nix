{ lib, windowManager, ... }:
with lib;
{
  imports = optional (windowManager == "hyprland") ./hyprland ++ optional (windowManager == "cosmic") ./cosmic;
  #imports = optional true ./hyprland;
}
