{ pkgs, ... }: {
  # Security
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };

  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        ScreenWidth = 1920;
        ScreenHeight = 1080;
        blur = true;
        recursiveBlurLoops = 3;
        recursiveBlurRadius = 5;
      };
    })
  ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin.user = "starnick";
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  programs.dconf = {
    enable = true;
  };

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = true;
    jack.enable = false;
  };
}
