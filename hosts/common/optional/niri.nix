{ niri, pkgs, ... }:
{
  # nixpkgs.overlays = [ niri.overlays.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  environment.variables.NIXOS_OZONE_WL = "1";

  # gnome portal delegates FileChooser to nautilus (not installed) -> use gtk for dialogs
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    unstable.xwayland-satellite
  ];
}
