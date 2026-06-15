{config, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    inherit (config) user;
    # Default folder for new synced folders.
    dataDir = "/home/${config.user}";
    # Folder for syncthing settings and keys.
    # https://docs.syncthing.net/users/config.html#configuration-file-locations
    configDir = "/home/${config.user}/.local/state/syncthing";
  };

  # Don't create default ~/Sync folder.
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
