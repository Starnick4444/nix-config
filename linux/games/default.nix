{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
  environment.systemPackages = with pkgs; [
    kdePackages.wayland-protocols
    mangohud
    protonup
  ];

  /*
  programs.nix-ld = {
    enable = true;

    libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
  };
  */
  /*
  libraries = with pkgs; [
    xorg.libXau
    xorg.libXrandr
    xorg.libX11
    libGL
    krb5
    glib
    glibc # maybe?
    libgcc.lib #maybe?
    nss # or nss3_latest?
    libz # new
    nspr
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXtst
    freetype
    expat
    fontconfig.lib
    dbus.lib
    alsa-lib
    xorg.libXrender
    xorg.libXdmcp

    libsForQt5.qt5.qtbase
  ];
  */

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/starnick/.steam/root/compatibilitytools.d";
  };
}
