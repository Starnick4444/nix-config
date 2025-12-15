{ pkgs, ... }:
{
  imports = [ ./nyaa.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ffmpeg
      spotify
      qbittorrent
      # stremio # insecure dependencies
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
