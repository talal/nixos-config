{config, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    inherit (config) user;
    dataDir = "/home/${config.user}"; # default folder for new synced folders
    # https://docs.syncthing.net/users/config.html#configuration-file-locations
    configDir = "/home/${config.user}/.local/state/syncthing"; # folder for syncthing settings and keys
  };

  # Don't create default ~/Sync folder.
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
