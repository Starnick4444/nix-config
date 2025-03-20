{ pkgs, ... }:
{
  imports = [ ./nyaa.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ffmpeg
      spotify
      mpv
      qbittorrent
      stremio
      ;
    inherit (pkgs.stable)
      calibre
      ;
  };
}
