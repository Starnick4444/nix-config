{pkgs, ...}: {
  imports = [./nyaa.nix];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      ffmpeg
      spotify
      mpv
      qbittorrent
      ;
    inherit
      (pkgs.stable)
      calibre
      ;
  };
}
