{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "primitiveeratools.com" = {
        hostname = "primitiveeratools.com";
        user = "root";
        identityFile = "/home/starnick/.ssh/id_endpc_simple";
      };
    };
  };
}
