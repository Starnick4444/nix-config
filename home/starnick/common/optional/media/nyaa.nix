{inputs, ...}: {
  imports = [inputs.nyaa.homeManagerModule];
  programs.nyaa = {
    enable = true;
    client.qBittorrent = {
      base_url = "http://localhost:8080";
      username = "admin";
      password = "adminadmin";
      savepath = "/home/bhdd/Torrents/";
      sequential_download = true;
    };
  };
}
