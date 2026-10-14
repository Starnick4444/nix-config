{ config, pkgs, ... }:
{
  programs.obs-studio.enable = true;

  # two loopback cams: video1 = OBS virtual camera, video2 = phone via scrcpy
  # phone cam: scrcpy --video-source=camera --camera-size=1920x1080 --no-audio --no-window --v4l2-sink=/dev/video2
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam","Phone Cam" exclusive_caps=1,1
  '';
  security.polkit.enable = true;

  # adb device access is handled by systemd uaccess rules (systemd >= 258)
  environment.systemPackages = [
    pkgs.scrcpy
    pkgs.android-tools
  ];
}
