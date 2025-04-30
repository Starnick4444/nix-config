{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];
}
