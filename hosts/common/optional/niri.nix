{ niri, pkgs, ... }:
{
  # nixpkgs.overlays = [ niri.overlays.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    # DISPLAY = ":0";
  };
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    xwayland-satellite
  ];
}
