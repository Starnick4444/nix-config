{
  inputs,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    # systemd.enable = true;
    # xwayland.enable = true;

    settings = {};
    extraConfig = (builtins.readFile ./hyprland.conf) + (builtins.readFile ./keybindings.conf) + (builtins.readFile ./windowrules.conf) + (builtins.readFile ./animations.conf);
  };

  programs.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  home.packages = with pkgs; [
    kitty
    hyprpaper
    xfce.thunar # file explorer
    pavucontrol # sound control
    waybar # status bar
    # TODO screenshot tool
    # TODO clipboard manager
    (pkgs.writeShellScriptBin "startup-apps" ''
      discord &
      spotify &
    '')
  ];
}
