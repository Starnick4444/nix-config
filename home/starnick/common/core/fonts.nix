{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    nerd-fonts.sauce-code-pro
    nerd-fonts.fira-code
    meslo-lgs-nf
  ];
}
