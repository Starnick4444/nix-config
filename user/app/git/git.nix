{ config, pkgs, userSettings, ... };

{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  programs.git.userName = "Starnick4444";
  programs.git.userEmail = "nemes.bence1@gmail.com";
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    safe.directory = "/home/" + "Starnick4444" + "/.dotfiles";
  };
}
