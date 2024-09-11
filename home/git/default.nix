_: {
  programs.git = {
    enable = true;
    userName = "Starnick4444";
    userEmail = "nemes.bence1@gmail.com";

    aliases = {
      # add
      a = "add"; # add
      chunkyadd = "add --patch"; # stage commits chunk by chunk
    };

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/starnick/.dotfiles";
    };
    ignores = [ "target" ];
  };
}
