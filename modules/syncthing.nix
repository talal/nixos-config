{
  services.syncthing = {
    enable = true;
    user = "talal";
    openDefaultPorts = true;
    dataDir = "/home/talal";
    # https://docs.syncthing.net/users/config.html#configuration-file-locations
    configDir = "/home/talal/.local/state/syncthing";
  };
}
