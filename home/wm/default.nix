{ lib, windowManager, ... }:
with lib;
{
  imports = optional (windowManager == "hyprland") ./hyprland;
  # imports = optional true ./hyprland;
}
