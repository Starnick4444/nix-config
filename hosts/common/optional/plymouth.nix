{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.adi1090x-plymouth-themes ];
  boot = {
    kernelParams = [
      "quiet" # shut up kernel output prior to prompts
    ];
    plymouth = {
      enable = true;
      theme = lib.mkForce "circle_hud";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "circle_hud" ]; })
      ];
    };
    consoleLogLevel = 0;
  };
}
