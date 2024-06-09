{ inputs, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    # systemd.enable = true;
  };
}
