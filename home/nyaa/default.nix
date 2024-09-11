_: 
{
  programs.nyaa = {
    enable = true;
    client.qBittorrent = {
      base_url = "http://localhost:8080";
      username = "admin";
      password = "adminadmin";
      # TODO change this to a xdg/env var path
      savepath = "/mnt/bhdd/Torrents/";
      sequential_download = true;
    };
  };
}
