{ pkgs
, ...
}: {
  home.packages = [ pkgs.git ];
  programs.git = {
    enable = true;
    userName = "Starnick4444";
    userEmail = "nemes.bence1@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/starnick/.dotfiles";
    };
    ignores = [ "target" ];
  };
}
