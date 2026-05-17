{config, ...}: {
  services.syncthing = {
    enable = true;
    inherit (config) user;
    openDefaultPorts = true;
    dataDir = "/home/${config.user}";
    # https://docs.syncthing.net/users/config.html#configuration-file-locations
    configDir = "/home/${config.user}/.local/state/syncthing";
  };
}
