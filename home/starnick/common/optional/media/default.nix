{ pkgs, ... }:
{
  imports = [ ./nyaa.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ffmpeg
      spotify
      qbittorrent
      stremio
      ;
    inherit (pkgs.stable)
      calibre
      ;
  };

  programs.mpv = {
    enable = true;
    config = {
      sub-scale = 0.72;
    };
  };
}
